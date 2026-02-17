class SeriesController < ApplicationController
  before_action :set_series, only: [ :show, :edit, :update, :destroy ]
  before_action(only: [ :edit, :update, :destroy ]) { require_series_producer(@series) }

  def index
    @series = Series.all
  end

  def show
  end

  def new
    @series = Series.new
  end

  def create
    @series = Series.new(series_params.merge(created_by_id: current_user.id))
    if @series.save
      redirect_to @series, notice: "Series was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @series.update(series_params)
      redirect_to @series, notice: "Series was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @series.destroy
    redirect_to series_index_path, notice: "Series was successfully destroyed."
  end

  private

  def set_series
    @series = Series.friendly.find(params[:id])
  end

  def series_params
    params.require(:series).permit(:name, :description)
  end
end
