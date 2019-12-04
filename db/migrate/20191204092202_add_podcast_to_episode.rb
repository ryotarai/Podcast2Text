class AddPodcastToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_reference :episodes, :podcast, foreign_key: true
  end
end
