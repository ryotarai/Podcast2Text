require 'tmpdir'
require 'shellwords'
require 'open3'
require 'securerandom'
require "google/cloud/storage"
require "google/cloud/speech"

class TranscribeEpisodeJob < ApplicationJob
  queue_as :default

  def perform(episode:, gcp_project_id:, gcp_bucket_name:, language_code:)
    Dir.mktmpdir do |dir|
      source = File.join(dir, "source.mp3")
      unless system("curl", "-L", "-o", source, episode.enclosure_url)
        raise "curl failed"
      end

      sample_rate_hertz = nil
      Open3.popen3(["ffprobe", source].shelljoin) do |stdin, stdout, stderr, wait|
        stdin.close
        err = stderr.read
        unless wait.value.success?
          raise "ffprobe failed: #{err}"
        end
        sample_rate_hertz = /Audio: .+ (\d+) Hz/.match(err)[1].to_i
      end

      output = "#{SecureRandom.uuid}.flac"
      unless system("ffmpeg", "-i", source, "-vn", "-ar", sample_rate_hertz.to_s, "-ac", "1", "-acodec", "flac", "-f", "flac", File.join(dir, output))
        raise "ffmpeg failed"
      end

      storage = Google::Cloud::Storage.new(project_id: gcp_project_id)
      bucket = storage.bucket(gcp_bucket_name)

      file = bucket.create_file(File.join(dir, output), output)

      speech = Google::Cloud::Speech.new
      encoding = :FLAC
      config = {
        model: 'default',
        encoding: encoding,
        sample_rate_hertz: sample_rate_hertz,
        language_code: language_code,
        enable_word_time_offsets: true,
        enable_automatic_punctuation: true,
        diarization_config: {
          enable_speaker_diarization: true,
        },
      }
      uri = "gs://#{gcp_bucket_name}/#{output}"
      audio = {uri: uri}

      operation = speech.long_running_recognize(config, audio) do |op|
        raise op.results.message if op.error?

        op.response.results.each do |result|
          alternatives = result.alternatives.map do |alt|
            words = alt.words.map do |word|
              EpisodeRecognitionWord.new(
                word: word.word,
                speaker_tag: word.speaker_tag,
                start_time: word.start_time.seconds * 1000000000 + word.start_time.nanos,
                end_time: word.end_time.seconds * 1000000000 + word.end_time.nanos,
              )
            end

            EpisodeRecognitionAlternative.new(
              transcript: alt.transcript,
              confidence: alt.confidence,
              episode_recognition_words: words,
            )
          end

          EpisodeRecognitionResult.create!(
            episode: episode,
            channel_tag: result.channel_tag,
            episode_recognition_alternatives: alternatives,
          )
        end
      end

      puts "Start to recognize audio"
      operation.wait_until_done!
    end
  end
end
