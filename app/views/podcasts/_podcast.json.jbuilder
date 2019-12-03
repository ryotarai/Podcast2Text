json.extract! podcast, :id, :name, :rss_url, :created_at, :updated_at
json.url podcast_url(podcast, format: :json)
