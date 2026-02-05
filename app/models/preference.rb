class Preference < ApplicationRecord
  belongs_to :user

  validates :min_year, numericality: { greater_than_or_equal_to: 1900, allow_nil: true }
  validates :max_year, numericality: { less_than_or_equal_to: Time.current.year, allow_nil: true }
  validates :min_rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, allow_nil: true }

  # Tratar favorite_genres como JSON
  def favorite_genres
    value = read_attribute(:favorite_genres)
    return [] if value.nil? || value.empty?
    
    begin
      JSON.parse(value)
    rescue JSON::ParserError
      []
    end
  end

  def favorite_genres=(value)
    if value.is_a?(Array)
      write_attribute(:favorite_genres, value.to_json)
    else
      write_attribute(:favorite_genres, value)
    end
  end

  def has_preferences?
    favorite_genres.present? || min_year.present? || max_year.present? || min_rating.present?
  end

  def genres_string
    return '' if favorite_genres.blank?
    favorite_genres.join(',')
  end
end