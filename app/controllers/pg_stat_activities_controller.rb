class PgStatActivitiesController < ApplicationController
  def index
    @pg_stat_activities = PgStatActivity.all
    render json: @pg_stat_activities.to_json
  end

  def show
    @pg_stat_activity = PgStatActivity.find(params[:id])
    render json: @pg_stat_activity.to_json
  end
end
