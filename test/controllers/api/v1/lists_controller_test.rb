require "test_helper"

class Api::V1::ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns all built-in lists" do
    get api_v1_lists_url
    assert_response :success
    json = JSON.parse(response.body)
    names = json.map { |l| l["name"] }
    assert_includes names, "Inbox"
    assert_includes names, "Today"
    assert_includes names, "Anytime"
    assert_includes names, "Upcoming"
    assert_includes names, "Someday"
    assert_includes names, "Logbook"
    assert_includes names, "Trash"
  end

  test "todos returns todos in list" do
    @mock_runner.stub(/to dos of list "Inbox"/, '[{"id":"1","name":"Task","status":"open"}]')
    get todos_api_v1_list_url("Inbox")
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size
  end
end
