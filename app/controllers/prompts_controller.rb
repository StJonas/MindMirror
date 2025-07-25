class PromptsController < ApplicationController
    before_action :set_prompt, only: %i[show update destroy]
  
    # GET /prompts
    def index
        @prompts = Prompt.all
    
        if params[:predefined].present?
          @prompts = @prompts.where(predefined: params[:predefined] == 'true')
        end
    
        if params[:weekly].present?
          @prompts = @prompts.where(weekly: params[:weekly] == 'true')
        end
    
        render json: @prompts
      end
  
    # GET /prompts/1
    def show
      render json: @prompt
    end
  
    # POST /prompts
    def create
      @prompt = Prompt.new(prompt_params)
  
      if @prompt.save
        render json: @prompt, status: :created, location: @prompt
      else
        render json: @prompt.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /prompts/1
    def update
      if @prompt.update(prompt_params)
        render json: @prompt
      else
        render json: @prompt.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /prompts/1
    def destroy
      @prompt.journal_entries.update_all(prompt_id: nil)
      @prompt.destroy
      head :no_content
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # GET /users/:user_id/prompts
    def user_prompts
      user = User.find(params[:user_id])
      prompts = user.prompts

      render json: prompts
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_prompt
      @prompt = Prompt.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def prompt_params
      params.require(:prompt).permit(:title, :weekly, :user_id, :predefined)
    end
  end