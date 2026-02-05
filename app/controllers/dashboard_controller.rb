class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @has_preferences = current_user.preference.has_preferences?
    @recommendations = current_user.recommendations.unwatched.recent.limit(12)
    @watched_count = current_user.recommendations.watched.count
  end
end