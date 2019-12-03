class CreateScripts < ActiveRecord::Migration[6.0]
  def change
    create_table :scripts do |t|
      t.string :audio_url
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
