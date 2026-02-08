class TmdbService
  include HTTParty
  base_uri 'https://api.themoviedb.org/3'

  def initialize
    @api_key = ENV['TMDB_API_KEY']
  end

  # Buscar todos os gêneros
  def genres
    response = self.class.get('/genre/movie/list', query: {
      api_key: @api_key,
      language: 'pt-BR'
    })
    
    if response.success?
      response['genres']
    else
      Rails.logger.error "TMDB API Error: #{response.code} - #{response.message}"
      nil
    end
  end

  # Descobrir filmes com filtros
  def discover_movies(params = {})
    query = {
      api_key: @api_key,
      language: params[:language] || 'pt-BR',
      sort_by: 'vote_average.desc',
      'vote_count.gte': 100,
      page: params[:page] || 1,
      include_adult: false
    }

    # Adicionar filtros opcionais
    query[:with_genres] = params[:genres] if params[:genres].present?
    query['primary_release_date.gte'] = "#{params[:min_year]}-01-01" if params[:min_year].present?
    query['primary_release_date.lte'] = "#{params[:max_year]}-12-31" if params[:max_year].present?
    query['vote_average.gte'] = params[:min_rating] if params[:min_rating].present?

    response = self.class.get('/discover/movie', query: query)
    
    if response.success?
      response['results']
    else
      Rails.logger.error "TMDB API Error: #{response.code} - #{response.message}"
      []
    end
  end

  # Buscar detalhes de um filme
  def movie_details(movie_id)
    response = self.class.get("/movie/#{movie_id}", query: {
      api_key: @api_key,
      language: 'pt-BR',
      append_to_response: 'credits,videos,images'
    })
    
    if response.success?
      response.parsed_response
    else
      Rails.logger.error "TMDB API Error: #{response.code} - #{response.message}"
      nil
    end
  end

  # Buscar filmes similares
  def similar_movies(movie_id)
    response = self.class.get("/movie/#{movie_id}/similar", query: {
      api_key: @api_key,
      language: 'pt-BR',
      page: 1
    })
    
    if response.success?
      response['results']
    else
      Rails.logger.error "TMDB API Error: #{response.code} - #{response.message}"
      []
    end
  end

  # Buscar filmes populares
  def popular_movies(page = 1)
    response = self.class.get('/movie/popular', query: {
      api_key: @api_key,
      language: 'pt-BR',
      page: page
    })
    
    if response.success?
      response['results']
    else
      Rails.logger.error "TMDB API Error: #{response.code} - #{response.message}"
      []
    end
  end

  # Buscar filme por ID TMDB
  def find_movie(tmdb_id)
    movie_details(tmdb_id)
  end

  # URL completa do poster
  def self.poster_url(path, size = 'w500')
    return nil unless path
    "https://image.tmdb.org/t/p/#{size}#{path}"
  end
  
  # URL completa do backdrop
  def self.backdrop_url(path, size = 'original')
    return nil unless path
    "https://image.tmdb.org/t/p/#{size}#{path}"
  end
end