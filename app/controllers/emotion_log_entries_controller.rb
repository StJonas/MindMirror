class EmotionLogEntriesController < ApplicationController
  before_action :set_emotion_log_entry, only: %i[ show update destroy ]

  # GET /emotion_log_entries
  def index
    if params[:user_id]
      @emotion_log_entries = EmotionLogEntry.joins(:emotion_log).where(emotion_logs: { user_id: params[:user_id] })
    else
      @emotion_log_entries = EmotionLogEntry.all
    end

    render json: @emotion_log_entries
  end

  # GET /emotion_log_entries/1
  def show
    render json: @emotion_log_entry
  end

  # POST /emotion_log_entries
  def create
    # Find or create the log for this user and date
    log = EmotionLog.find_or_create_by(user_id: params[:emotion_log_entry][:user_id], date: params[:emotion_log_entry][:date])

    # Build the entry associated with the log
    @emotion_log_entry = log.emotion_log_entries.build(
      emotion_id: params[:emotion_log_entry][:emotion_id],
      content: params[:emotion_log_entry][:content]
    )

    if @emotion_log_entry.save
      render json: @emotion_log_entry, status: :created, location: @emotion_log_entry
    else
      render json: @emotion_log_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emotion_log_entries/1
  def update
    if @emotion_log_entry.update(emotion_log_entry_params)
      render json: @emotion_log_entry
    else
      render json: @emotion_log_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emotion_log_entries/1
  def destroy
    @emotion_log_entry.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emotion_log_entry
      @emotion_log_entry = EmotionLogEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def emotion_log_entry_params
      params.require(:emotion_log_entry).permit(:user_id, :date, :emotion_id, :content)
    end
end
