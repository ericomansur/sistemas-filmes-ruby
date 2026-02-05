class Recommendation < ApplicationRecord
  belongs_to :user

  validates :tmdb_id, presence: true, uniqueness: { scope: :user_id }
  validates :title, presence: true

  scope :unwatched, -> { where(watched: false) }
  scope :watched, -> { where(watched: true) }
  scope :recent, -> { order(created_at: :desc) }

  def poster_url(size = 'w500')
    TmdbService.poster_url(poster_path, size)
  end

  def mark_as_watched!
    update(watched: true)
  end
end