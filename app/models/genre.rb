class Genre < ApplicationRecord
  validates :tmdb_id, presence: true, uniqueness: true
  validates :name, presence: true

  def self.sync_from_tmdb
    service = TmdbService.new
    genres = service.genres

    return unless genres

    genres.each do |genre_data|
      Genre.find_or_create_by(tmdb_id: genre_data['id']) do |genre|
        genre.name = genre_data['name']
      end
    end
  end
end