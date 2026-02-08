require "test_helper"

class Api::V1::SelectedControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns selected todos" do
    @mock_runner.stub(/selected to dos/, '[{"id":"1","name":"Selected","status":"open"}]')
    get api_v1_selected_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size
    assert_equal "Selected", json.first["name"]
  end

  test "index returns empty array when nothing selected" do
    @mock_runner.stub(/selected to dos/, "[]")
    get api_v1_selected_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal [], json
  end
end
