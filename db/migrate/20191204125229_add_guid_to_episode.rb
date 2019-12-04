class AddGuidToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :guid, :string
  end
end
