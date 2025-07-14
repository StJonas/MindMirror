class RechargeExercisesController < ApplicationController
  before_action :set_recharge_exercise, only: %i[ show update destroy ]

  # GET /recharge_exercises
  def index
    @recharge_exercises = RechargeExercise.all

    render json: @recharge_exercises
  end

  # GET /recharge_exercises/1
  def show
    render json: @recharge_exercise
  end

  # POST /recharge_exercises
  def create
    @recharge_exercise = RechargeExercise.new(recharge_exercise_params)

    if @recharge_exercise.save
      render json: @recharge_exercise, status: :created, location: @recharge_exercise
    else
      render json: @recharge_exercise.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recharge_exercises/1
  def update
    if @recharge_exercise.update(recharge_exercise_params)
      render json: @recharge_exercise
    else
      render json: @recharge_exercise.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recharge_exercises/1
  def destroy
    @recharge_exercise.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recharge_exercise
      @recharge_exercise = RechargeExercise.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recharge_exercise_params
      params.require(:recharge_exercise).permit(:title, :description, :active)
    end
end
