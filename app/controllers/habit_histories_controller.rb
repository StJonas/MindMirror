class HabitHistoriesController < ApplicationController
  before_action :set_habit_history, only: %i[ show update destroy ]

  # GET /habit_histories
  def index
    # Find the user and habit using provided IDs
    user = User.find(params[:user_id])
    habit = user.habits.find_by(id: params[:habit_id])

    if habit
      # Filter habit histories for the specified week (if provided)
      week_start = params[:week_start] ? Date.parse(params[:week_start]) : Date.today.beginning_of_week
      week_end = week_start.end_of_week

      habit_histories = habit.habit_histories.where(date: week_start..week_end)

      render json: habit_histories
    else
      render json: { error: "Habit not found for the specified user" }, status: :not_found
    end
  end

  # GET /habit_histories/week
  def week
    user = User.find(params[:user_id])
    habit = Habit.find(params[:habit_id])
    current_week_start = DateTime.parse(params[:currentDay])
    week_end = current_week_start.end_of_week

    habit_histories = habit.habit_histories.where(date: current_week_start..week_end)

    render json: habit_histories
  end


  # GET /habit_histories/1
  def show
    render json: @habit_history
  end

  # POST /habit_histories
  def create
    @habit_histories = habit_history_params.map do |history_params|
      HabitHistory.new(history_params)
    end

    if @habit_histories.all?(&:save)
      render json: @habit_histories, status: :created, location: @habit_histories
    else
      render json: @habit_histories.map(&:errors), status: :unprocessable_entity
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
    @habit_history.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit_history
      @habit_history = HabitHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def habit_history_params
      params.require(:_json).map do |history|
        ActionController::Parameters.new(history.to_unsafe_h).permit(:habit_id, :user_id, :date, :completed)
      end
    end
end