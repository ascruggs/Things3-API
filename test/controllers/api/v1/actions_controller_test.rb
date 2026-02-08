require "test_helper"

class Api::V1::ActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "empty_trash returns 204" do
    @mock_runner.stub(/empty trash/, "")
    post api_v1_empty_trash_url
    assert_response :no_content
  end

  test "log_completed returns 204" do
    @mock_runner.stub(/log completed now/, "")
    post api_v1_log_completed_url
    assert_response :no_content
  end

  test "quick_entry returns 204" do
    @mock_runner.stub(/show quick entry panel/, "")
    post api_v1_quick_entry_url
    assert_response :no_content
  end

  test "quick_entry with params passes properties" do
    @mock_runner.stub(/show quick entry panel/, "")
    post api_v1_quick_entry_url, params: { name: "Task", notes: "Details" }, as: :json
    assert_response :no_content
    assert @mock_runner.executed_scripts.last.include?("with properties")
  end
end
