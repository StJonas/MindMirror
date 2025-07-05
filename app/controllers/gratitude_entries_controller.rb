class GratitudeEntriesController < ApplicationController
  before_action :set_gratitude_entry, only: %i[ show update destroy ]

  # GET /gratitude_entries
  def index
    @gratitude_entries = GratitudeEntry.all

    render json: @gratitude_entries
  end

  # GET /gratitude_entries/1
  def show
    render json: @gratitude_entry
  end

  # POST /gratitude_entries
  def create
    @gratitude_entry = GratitudeEntry.new(gratitude_entry_params)

    if @gratitude_entry.save
      render json: @gratitude_entry, status: :created, location: @gratitude_entry
    else
      render json: @gratitude_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /gratitude_entries/1
  def update
    if @gratitude_entry.update(gratitude_entry_params)
      render json: @gratitude_entry
    else
      render json: @gratitude_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /gratitude_entries/1
  def destroy
    @gratitude_entry.destroy!
  end

  # GET /users/:user_id/gratitude_entries
    def user_gratitude_entries
      user = User.find(params[:user_id])
      gratitude_entries = user.gratitude_entries

      render json: gratitude_entries
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gratitude_entry
      @gratitude_entry = GratitudeEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gratitude_entry_params
      params.require(:gratitude_entry).permit(:content, :entry_date, :user_id, :gratitude_prompt_id, :prompt_title)
    end
end
