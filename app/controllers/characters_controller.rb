class CharactersController < ApplicationController
  before_action :set_series, only: [ :new, :create ]
  before_action :set_character, only: [ :show ]
  before_action(only: [ :new, :create ]) { require_series_producer(@series) }

  def show
    @series = @character.series
  end

  def new
    @character = @series.cast.build
  end

  def create
    @character = @series.cast.build(character_params)
    if @character.save
      redirect_to @series, notice: "Character was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_series
    @series = Series.friendly.find(params[:series_id])
  end

  def set_character
    @character = Character.find(params[:id])
  end

  def character_params
    params.require(:character).permit(:name)
  end
end
