class PgStatActivitiesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    pg_stat_activities = PgStatActivity.all
    render json: pg_stat_activities.to_json
  end

  def show
    pg_stat_activity = PgStatActivity.find(params[:id])
    render json: pg_stat_activity.to_json
  end

  def destroy
    pg_stat_activity = PgStatActivity.find(params[:id])
    pg_stat_activity.cancel_backend!
    render json: pg_stat_activity.to_json
  end
end
