class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference

  def edit
    @genres = Genre.all
    # Sincronizar gêneros do TMDB se não existirem
    if @genres.empty?
      Genre.sync_from_tmdb
      @genres = Genre.all
    end
  end

  def update
    if @preference.update(preference_params)
      redirect_to recommendations_path, notice: 'Preferências atualizadas com sucesso! Gerando recomendações...'
    else
      @genres = Genre.all
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_preference
    @preference = current_user.preference
  end

  def preference_params
    params.require(:preference).permit(
      :min_year,
      :max_year,
      :min_rating,
      :preferred_language,
      favorite_genres: []
    )
  end
end