require "test_helper"

class GratitudePromptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gratitude_prompt = gratitude_prompts(:one)
  end

  test "should get index" do
    get gratitude_prompts_url, as: :json
    assert_response :success
  end

  test "should create gratitude_prompt" do
    assert_difference("GratitudePrompt.count") do
      post gratitude_prompts_url, params: { gratitude_prompt: { predefined: @gratitude_prompt.predefined, title: @gratitude_prompt.title, user_id: @gratitude_prompt.user_id, weekly: @gratitude_prompt.weekly } }, as: :json
    end

    assert_response :created
  end

  test "should show gratitude_prompt" do
    get gratitude_prompt_url(@gratitude_prompt), as: :json
    assert_response :success
  end

  test "should update gratitude_prompt" do
    patch gratitude_prompt_url(@gratitude_prompt), params: { gratitude_prompt: { predefined: @gratitude_prompt.predefined, title: @gratitude_prompt.title, user_id: @gratitude_prompt.user_id, weekly: @gratitude_prompt.weekly } }, as: :json
    assert_response :success
  end

  test "should destroy gratitude_prompt" do
    assert_difference("GratitudePrompt.count", -1) do
      delete gratitude_prompt_url(@gratitude_prompt), as: :json
    end

    assert_response :no_content
  end
end
