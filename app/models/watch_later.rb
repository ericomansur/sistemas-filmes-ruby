class WatchLater < ApplicationRecord
  belongs_to :user

  validates :tmdb_id, presence: true, uniqueness: { scope: :user_id }
  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def poster_url(size = 'w500')
    TmdbService.poster_url(poster_path, size)
  end

  def genre_ids_array
    return [] if genre_ids.blank?
    
    begin
      JSON.parse(genre_ids)
    rescue JSON::ParserError
      []
    end
  end

  def genre_ids_array=(value)
    if value.is_a?(Array)
      write_attribute(:genre_ids, value.to_json)
    else
      write_attribute(:genre_ids, value)
    end
  end
end