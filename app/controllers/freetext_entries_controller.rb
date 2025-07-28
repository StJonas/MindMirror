class FreetextEntriesController < ApplicationController
  before_action :set_freetext_entry, only: %i[ show update destroy ]

  # GET /freetext_entries
  def index
    if params[:user_id]
      @freetext_entries = FreetextEntry.where(user_id: params[:user_id])
    else
      @freetext_entries = FreetextEntry.none
    end
    render json: @freetext_entries
  end

  # GET /freetext_entries/1
  def show
    render json: @freetext_entry
  end

  # POST /freetext_entries
  def create
    @freetext_entry = FreetextEntry.new(freetext_entry_params)

    if @freetext_entry.save
      render json: @freetext_entry, status: :created, location: @freetext_entry
    else
      render json: @freetext_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /freetext_entries/1
  def update
    if @freetext_entry.update(freetext_entry_params)
      render json: @freetext_entry
    else
      render json: @freetext_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /freetext_entries/1
  def destroy
    @freetext_entry.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_freetext_entry
      @freetext_entry = FreetextEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def freetext_entry_params
      params.require(:freetext_entry).permit(:user_id, :content, :date, :done_offline)
    end
end
