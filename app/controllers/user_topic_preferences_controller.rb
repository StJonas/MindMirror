class UserTopicPreferencesController < ApplicationController
  before_action :set_user_topic_preference, only: %i[ show update destroy ]

  # GET /user_topic_preferences
  def index
    user = User.find(params[:user_id])
    topics = user.user_topic_preferences.pluck(:topic_name)
    render json: { topics: topics }
  end

  # GET /user_topic_preferences/1
  def show
    render json: @user_topic_preference
  end

  # POST /user_topic_preferences
  def create
    user = User.find(params[:user_id])
    user.user_topic_preferences.destroy_all
    params[:topics].each do |topic_name|
      user.user_topic_preferences.create(topic_name: topic_name)
    end
    render json: { success: true }
  end

  # PATCH/PUT /user_topic_preferences/1
  def update
    if @user_topic_preference.update(user_topic_preference_params)
      render json: @user_topic_preference
    else
      render json: @user_topic_preference.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_topic_preferences/1
  def destroy
    @user_topic_preference.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_topic_preference
      @user_topic_preference = UserTopicPreference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_topic_preference_params
      params.require(:user_topic_preference).permit(:user_id, :topic_name)
    end
end
