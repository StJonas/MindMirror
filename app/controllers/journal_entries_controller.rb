class JournalEntriesController < ApplicationController
    before_action :set_journal_entry, only: %i[show update destroy]
  
    # GET /journal_entries
    def index
      @journal_entries = JournalEntry.all
      render json: @journal_entries
    end
  
    # GET /journal_entries/1
    def show
      render json: @journal_entry
    end
  
    # POST /journal_entries
    def create
      @journal_entry = JournalEntry.new(journal_entry_params)
  
      if @journal_entry.save
        render json: @journal_entry, status: :created, location: @journal_entry
      else
        render json: @journal_entry.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /journal_entries/1
    def update
      if @journal_entry.update(journal_entry_params)
        render json: @journal_entry
      else
        render json: @journal_entry.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /journal_entries/1
    def destroy
      @journal_entry.destroy
    end

    # GET /users/:user_id/journal_entries
    def user_journal_entries
      user = User.find(params[:user_id])
      journal_entries = user.journal_entries

      render json: journal_entries
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_journal_entry
      @journal_entry = JournalEntry.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def journal_entry_params
      params.require(:journal_entry).permit(:content, :entry_date, :user_id, :prompt_id, :prompt_title)
    end
  end