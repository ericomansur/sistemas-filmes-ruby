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
    response['genres'] if response.success?
  end

  # Descobrir filmes com filtros
  def discover_movies(params = {})
    query = {
      api_key: @api_key,
      language: params[:language] || 'pt-BR',
      sort_by: 'vote_average.desc',
      'vote_count.gte': 100,
      page: params[:page] || 1
    }

    # Adicionar filtros opcionais
    query[:with_genres] = params[:genres] if params[:genres].present?
    query['primary_release_date.gte'] = "#{params[:min_year]}-01-01" if params[:min_year].present?
    query['primary_release_date.lte'] = "#{params[:max_year]}-12-31" if params[:max_year].present?
    query['vote_average.gte'] = params[:min_rating] if params[:min_rating].present?

    response = self.class.get('/discover/movie', query: query)
    response['results'] if response.success?
  end

  # Buscar detalhes de um filme
  def movie_details(movie_id)
    response = self.class.get("/movie/#{movie_id}", query: {
      api_key: @api_key,
      language: 'pt-BR'
    })
    response if response.success?
  end

  # Buscar filmes similares
  def similar_movies(movie_id)
    response = self.class.get("/movie/#{movie_id}/similar", query: {
      api_key: @api_key,
      language: 'pt-BR'
    })
    response['results'] if response.success?
  end

  # Buscar filmes populares
  def popular_movies(page = 1)
    response = self.class.get('/movie/popular', query: {
      api_key: @api_key,
      language: 'pt-BR',
      page: page
    })
    response['results'] if response.success?
  end

  # URL completa do poster
  def self.poster_url(path, size = 'w500')
    return nil unless path
    "https://image.tmdb.org/t/p/#{size}#{path}"
  end
end