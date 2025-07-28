class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  def update_stats_visibility
    user = User.find(params[:id])
    if params[:stats_visibility].present?
      user.update(stats_visibility: params[:stats_visibility])
      render json: { success: true }
    else
      render json: { error: "Missing stats_visibility" }, status: :unprocessable_entity
    end
  end

  # GET /users/1
  def show
    render json: @user.as_json(only: [:id, :username, :stats_visibility])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :stats_visibility)
    end
end
