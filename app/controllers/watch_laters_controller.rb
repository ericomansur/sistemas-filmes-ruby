class WatchLatersController < ApplicationController
  before_action :authenticate_user!

  def index
    @watch_laters = current_user.watch_laters.recent.page(params[:page]).per(12)
  end

  def create
    tmdb_id = params[:tmdb_id]
    service = TmdbService.new
    movie = service.find_movie(tmdb_id)

    if movie
      watch_later = current_user.watch_laters.find_or_initialize_by(tmdb_id: tmdb_id)
      
      watch_later.assign_attributes(
        title: movie['title'],
        poster_path: movie['poster_path'],
        overview: movie['overview'],
        rating: movie['vote_average'],
        genre_ids_array: movie['genre_ids'] || [],
        release_date: movie['release_date']
      )

      if watch_later.save
        redirect_back fallback_location: root_path, notice: 'Filme adicionado à lista "Assistir Mais Tarde"!'
      else
        redirect_back fallback_location: root_path, alert: 'Erro ao adicionar filme.'
      end
    else
      redirect_back fallback_location: root_path, alert: 'Filme não encontrado.'
    end
  end

  def destroy
    @watch_later = current_user.watch_laters.find(params[:id])
    @watch_later.destroy
    redirect_to watch_laters_path, notice: 'Filme removido da lista!'
  end

  def add_from_tmdb
    tmdb_id = params[:tmdb_id]
    create
  end
end