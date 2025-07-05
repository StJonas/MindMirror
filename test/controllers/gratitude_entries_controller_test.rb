require "test_helper"

class GratitudeEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gratitude_entry = gratitude_entries(:one)
  end

  test "should get index" do
    get gratitude_entries_url, as: :json
    assert_response :success
  end

  test "should create gratitude_entry" do
    assert_difference("GratitudeEntry.count") do
      post gratitude_entries_url, params: { gratitude_entry: { content: @gratitude_entry.content, entry_date: @gratitude_entry.entry_date, gratitude_prompt_id: @gratitude_entry.gratitude_prompt_id, prompt_title: @gratitude_entry.prompt_title, user_id: @gratitude_entry.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show gratitude_entry" do
    get gratitude_entry_url(@gratitude_entry), as: :json
    assert_response :success
  end

  test "should update gratitude_entry" do
    patch gratitude_entry_url(@gratitude_entry), params: { gratitude_entry: { content: @gratitude_entry.content, entry_date: @gratitude_entry.entry_date, gratitude_prompt_id: @gratitude_entry.gratitude_prompt_id, prompt_title: @gratitude_entry.prompt_title, user_id: @gratitude_entry.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy gratitude_entry" do
    assert_difference("GratitudeEntry.count", -1) do
      delete gratitude_entry_url(@gratitude_entry), as: :json
    end

    assert_response :no_content
  end
end
