require "test_helper"

class HabitHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @habit_history = habit_histories(:one)
  end

  test "should get index" do
    get habit_histories_url, as: :json
    assert_response :success
  end

  test "should create habit_history" do
    assert_difference("HabitHistory.count") do
      post habit_histories_url, params: { habit_history: { completed: @habit_history.completed, date: @habit_history.date, habit_id: @habit_history.habit_id, user_id: @habit_history.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show habit_history" do
    get habit_history_url(@habit_history), as: :json
    assert_response :success
  end

  test "should update habit_history" do
    patch habit_history_url(@habit_history), params: { habit_history: { completed: @habit_history.completed, date: @habit_history.date, habit_id: @habit_history.habit_id, user_id: @habit_history.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy habit_history" do
    assert_difference("HabitHistory.count", -1) do
      delete habit_history_url(@habit_history), as: :json
    end

    assert_response :no_content
  end
end
