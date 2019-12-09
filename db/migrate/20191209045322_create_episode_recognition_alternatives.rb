class CreateEpisodeRecognitionAlternatives < ActiveRecord::Migration[6.0]
  def change
    create_table :episode_recognition_alternatives do |t|
      t.references :episode_recognition_result, null: false, foreign_key: true, index: {name: 'index_alternatives_on_result_id'}
      t.float :confidence
      t.text :transcript

      t.timestamps
    end
  end
end
