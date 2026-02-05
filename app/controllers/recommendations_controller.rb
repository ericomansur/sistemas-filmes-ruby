class RecommendationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @recommendations = current_user.recommendations.unwatched.recent.page(params[:page]).per(12)
    
    # Gerar recomendações se não existirem
    if @recommendations.empty? && current_user.preference.has_preferences?
      generate_recommendations
      @recommendations = current_user.recommendations.unwatched.recent.page(params[:page]).per(12)
    end

    @watched_recommendations = current_user.recommendations.watched.recent.limit(6)
  end

  def show
    @recommendation = current_user.recommendations.find(params[:id])
    @tmdb_service = TmdbService.new
    @movie_details = @tmdb_service.movie_details(@recommendation.tmdb_id)
    @similar_movies = @tmdb_service.similar_movies(@recommendation.tmdb_id)
  end

  def mark_watched
    @recommendation = current_user.recommendations.find(params[:id])
    @recommendation.mark_as_watched!
    redirect_to recommendations_path, notice: 'Filme marcado como assistido!'
  end

  def generate
    generate_recommendations
    redirect_to recommendations_path, notice: 'Novas recomendações geradas!'
  end

  def destroy
    @recommendation = current_user.recommendations.find(params[:id])
    @recommendation.destroy
    redirect_to recommendations_path, notice: 'Recomendação removida!'
  end

  private

  def generate_recommendations
    preference = current_user.preference
    return unless preference.has_preferences?

    service = TmdbService.new
    
    # Limpar recomendações antigas não assistidas
    current_user.recommendations.unwatched.destroy_all

    # Buscar filmes com base nas preferências
    movies = service.discover_movies(
      genres: preference.genres_string,
      min_year: preference.min_year,
      max_year: preference.max_year,
      min_rating: preference.min_rating,
      language: preference.preferred_language || 'pt-BR'
    )

    # Salvar como recomendações
    movies&.first(20)&.each do |movie|
      current_user.recommendations.find_or_create_by(tmdb_id: movie['id']) do |rec|
        rec.title = movie['title']
        rec.poster_path = movie['poster_path']
        rec.overview = movie['overview']
        rec.rating = movie['vote_average']
        rec.watched = false
      end
    end
  rescue => e
    Rails.logger.error "Erro ao gerar recomendações: #{e.message}"
  end
end