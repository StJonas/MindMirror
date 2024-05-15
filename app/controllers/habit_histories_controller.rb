class HabitHistoriesController < ApplicationController
  before_action :set_habit_history, only: %i[ show update destroy ]

  # GET /habit_histories
  def index
    @habit_histories = HabitHistory.all

    render json: @habit_histories
  end

  # GET /habit_histories/1
  def show
    render json: @habit_history
  end

  # POST /habit_histories
  def create
    @habit_history = HabitHistory.new(habit_history_params)

    if @habit_history.save
      render json: @habit_history, status: :created, location: @habit_history
    else
      render json: @habit_history.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /habit_histories/1
  def update
    if @habit_history.update(habit_history_params)
      render json: @habit_history
    else
      render json: @habit_history.errors, status: :unprocessable_entity
    end
  end

  # DELETE /habit_histories/1
  def destroy
    @habit_history.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit_history
      @habit_history = HabitHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def habit_history_params
      params.require(:habit_history).permit(:habit_id, :user_id, :date, :completed)
    end
end
