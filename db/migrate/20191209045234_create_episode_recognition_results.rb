class CreateEpisodeRecognitionResults < ActiveRecord::Migration[6.0]
  def change
    create_table :episode_recognition_results do |t|
      t.references :episode, null: false, foreign_key: true
      t.integer :channel_tag

      t.timestamps
    end
  end
end
