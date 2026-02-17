class EpisodesController < ApplicationController
  before_action :set_series, only: [ :index, :new, :create ]
  before_action :set_episode, only: [ :show, :edit, :update, :destroy ]
  before_action :require_episode_series_producer, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @episodes = @series.episodes
  end

  def show
    @series = @episode.series
  end

  def new
    @episode = @series.episodes.build
  end

  def create
    @episode = @series.episodes.build(episode_params)
    if @episode.save
      redirect_to @episode, notice: "Episode was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @series = @episode.series
  end

  def update
    if @episode.update(episode_params)
      redirect_to @episode, notice: "Episode was successfully updated."
    else
      @series = @episode.series
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    series = @episode.series
    @episode.destroy
    redirect_to series, notice: "Episode was successfully destroyed."
  end

  private

  def set_series
    @series = Series.friendly.find(params[:series_id])
  end

  def set_episode
    @episode = Episode.friendly.find(params[:id])
  end

  def require_episode_series_producer
    series = @series || @episode&.series
    require_series_producer(series) if series
  end

  def episode_params
    params.require(:episode).permit(:title, :session_date, :notes)
  end
end
