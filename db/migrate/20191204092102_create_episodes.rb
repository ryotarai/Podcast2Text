class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :enclosure_url

      t.timestamps
    end
  end
end
