class CreateEpisodeRecognitionWords < ActiveRecord::Migration[6.0]
  def change
    create_table :episode_recognition_words do |t|
      t.references :episode_recognition_alternative, null: false, foreign_key: true, index: {name: 'index_words_on_alternative_id'}
      t.string :word
      t.integer :speaker_tag
      t.integer :end_time, limit: 8
      t.integer :start_time, limit: 8

      t.timestamps
    end
  end
end
