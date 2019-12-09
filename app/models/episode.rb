class Episode < ApplicationRecord
  has_many :episode_recognition_results, dependent: :destroy
end
