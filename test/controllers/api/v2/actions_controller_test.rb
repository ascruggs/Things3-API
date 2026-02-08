require "test_helper"

class Api::V2::ActionsControllerTest < ActionDispatch::IntegrationTest
  test "empty_trash returns 204" do
    post api_v2_empty_trash_url
    assert_response :no_content
  end

  test "log_completed returns 204" do
    @mock_runner.stub("log completed", "")
    post api_v2_log_completed_url
    assert_response :no_content
  end

  test "quick_entry returns 204" do
    @mock_runner.stub("quick entry", "")
    post api_v2_quick_entry_url
    assert_response :no_content
  end

  test "quick_entry with params returns 204" do
    @mock_runner.stub("quick entry", "")
    post api_v2_quick_entry_url, params: { name: "Test", notes: "Details" }, as: :json
    assert_response :no_content
  end
end
