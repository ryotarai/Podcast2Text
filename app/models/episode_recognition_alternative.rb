class EpisodeRecognitionAlternative < ApplicationRecord
  belongs_to :episode_recognition_result
  has_many :episode_recognition_words, dependent: :destroy
end
