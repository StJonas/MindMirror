class GratitudePromptsController < ApplicationController
  before_action :set_gratitude_prompt, only: %i[ show update destroy ]

  # GET /gratitude_prompts
  def index
    if params[:predefined] == "true"
      @gratitude_prompts = GratitudePrompt.where(predefined: true)
    else
      @gratitude_prompts = GratitudePrompt.all
    end
    render json: @gratitude_prompts
  end

  # GET /gratitude_prompts/1
  def show
    render json: @gratitude_prompt
  end

  # POST /gratitude_prompts
  def create
    @gratitude_prompt = GratitudePrompt.new(gratitude_prompt_params)

    if @gratitude_prompt.save
      render json: @gratitude_prompt, status: :created, location: @gratitude_prompt
    else
      render json: @gratitude_prompt.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /gratitude_prompts/1
  def update
    if @gratitude_prompt.update(gratitude_prompt_params)
      render json: @gratitude_prompt
    else
      render json: @gratitude_prompt.errors, status: :unprocessable_entity
    end
  end

  # DELETE /gratitude_prompts/1
  def destroy
    GratitudeEntry.where(gratitude_prompt_id: params[:id]).update_all(gratitude_prompt_id: nil)
    @gratitude_prompt = GratitudePrompt.find(params[:id])
    @gratitude_prompt.destroy!
  end

  # GET /users/:user_id/gratitude_prompts
  def user_gratitude_prompts
    user = User.find(params[:user_id])
    gratitude_prompts = user.gratitude_prompts

    render json: gratitude_prompts
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gratitude_prompt
      @gratitude_prompt = GratitudePrompt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gratitude_prompt_params
      params.require(:gratitude_prompt).permit(:title, :predefined, :weekly, :user_id)
    end
end
