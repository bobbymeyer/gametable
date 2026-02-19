class LocationsController < ApplicationController
  before_action :set_series, only: [ :new, :create ]
  before_action :set_location, only: [ :edit, :update, :destroy ]
  before_action(only: [ :new, :create ]) { require_series_producer(@series) }
  before_action(only: [ :edit, :update, :destroy ]) { require_series_producer(@location.series) }

  def new
    @location = @series.locations.build
  end

  def create
    @location = @series.locations.build(location_params)
    if @location.save
      redirect_to series_path(@series, anchor: "locations"), notice: "Location was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @series = @location.series
  end

  def update
    if @location.update(location_params)
      redirect_to series_path(@location.series, anchor: "locations"), notice: "Location was successfully updated."
    else
      @series = @location.series
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    series = @location.series
    @location.destroy
    redirect_to series_path(series, anchor: "locations"), notice: "Location was successfully destroyed."
  end

  private

  def set_series
    @series = Series.friendly.find(params[:series_id])
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :backdrop)
  end
end
