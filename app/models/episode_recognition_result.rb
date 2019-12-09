class EpisodeRecognitionResult < ApplicationRecord
  belongs_to :episode
  has_many :episode_recognition_alternatives, dependent: :destroy
end
