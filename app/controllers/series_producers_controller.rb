class SeriesProducersController < ApplicationController
  before_action :set_series
  before_action(only: [ :index, :create, :destroy ]) { require_series_executive_producer(@series) }

  def index
    @series_producers = @series.series_producers.includes(:user)
  end

  def create
    user = User.find_by(email: params[:email])
    unless user
      redirect_to series_series_producers_path(@series), alert: "No user found with that email."
      return
    end

    @series_producer = @series.series_producers.build(user: user)
    if @series_producer.save
      redirect_to series_series_producers_path(@series), notice: "#{user.email} was added as a producer."
    else
      redirect_to series_series_producers_path(@series), alert: @series_producer.errors.full_messages.to_sentence
    end
  end

  def destroy
    @series_producer = @series.series_producers.find(params[:id])
    @series_producer.destroy
    redirect_to series_series_producers_path(@series), notice: "Producer was removed."
  end

  private

  def set_series
    @series = Series.friendly.find(params[:series_id])
  end
end
