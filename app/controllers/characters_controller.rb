class CharactersController < ApplicationController
  before_action :set_series, only: [ :new, :create ]
  before_action :set_character, only: [ :show, :generate_portrait ]
  before_action(only: [ :new, :create ]) { require_series_producer(@series) }
  before_action(only: [ :generate_portrait ]) { require_series_producer(@character.series) }

  def show
    @series = @character.series
  end

  def generate_portrait
    prompt = params[:prompt].to_s.presence || default_portrait_prompt
    ::ComfyUI::RunWorkflowJob.perform_later(
      "placeholder",
      { "prompt" => prompt },
      "attach" => { "record" => "Character", "id" => @character.id, "name" => "portrait" }
    )
    redirect_to @character, notice: "Portrait generation started. It may take a minute to appear."
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

  def default_portrait_prompt
    "Small portrait of #{@character.name}, head and shoulders, fantasy character art style"
  end
end
