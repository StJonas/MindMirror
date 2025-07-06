class HabitsController < ApplicationController
  before_action :set_habit, only: %i[ show update destroy update_duration ]

  # GET /habits
  def index
    if params[:user_id]
      @habits = Habit.where(user_id: params[:user_id])
    else
      @habits = Habit.all
    end

    render json: @habits
  end

  # GET /habits/user_id
  def index_by_user
    @user = User.find(params[:user_id])
    @habits = @user.habits
    render json: @habits
  end

  # GET /habits/1
  def show
    render json: @habit
  end

  # POST /habits
  def create
    @habit = Habit.new(habit_params)

    if @habit.save
      render json: @habit, status: :created, location: @habit
    else
      render json: @habit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /habits/1
  def update
    if @habit.update(habit_params)
      render json: @habit
    else
      render json: @habit.errors, status: :unprocessable_entity
    end
  end

  # DELETE /habits/1
  def destroy
    @habit.destroy!
  end

  # POST /habits/:id/update_duration
  def update_duration
    if @habit.update(duration_params)
      render json: @habit
    else
      render json: @habit.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit
      @habit = Habit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def habit_params
      params.require(:habit).permit(:id, :name, :frequency, :user_id, :category_id, :is_timed, :description)
    end

    def duration_params
      params.require(:habit).permit(:duration)
    end
end
