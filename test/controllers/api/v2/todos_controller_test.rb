require "test_helper"

class Api::V2::TodosControllerTest < ActionDispatch::IntegrationTest
  # Index
  test "index returns todos" do
    @mock_runner.stub("to dos", '[{"id":"T1","name":"Test"}]')
    get api_v2_todos_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end

  # Show
  test "show returns a todo" do
    @mock_runner.stub("to do id", '{"id":"T1","name":"Test"}')
    get api_v2_todo_url("T1")
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "T1", json["id"]
  end

  test "show returns 404 for missing todo" do
    @mock_runner.stub("to do id", ThingsScript::NotFoundError.new("not found"))
    get api_v2_todo_url("MISSING")
    assert_response :not_found
  end

  # Create (URL scheme)
  test "create returns 201" do
    post api_v2_todos_url, params: { title: "Buy milk" }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "Buy milk", json["title"]
  end

  test "create returns 400 without title" do
    post api_v2_todos_url, params: { notes: "no title" }, as: :json
    assert_response :bad_request
  end

  # Update (URL scheme)
  test "update returns 200" do
    patch api_v2_todo_url("ABC"), params: { title: "Updated" }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "ABC", json["id"]
    assert_equal "Updated", json["title"]
  end

  test "update returns 401 without auth token" do
    ThingsShortcut.auth_token = nil
    patch api_v2_todo_url("ABC"), params: { title: "Updated" }, as: :json
    assert_response :unauthorized
  end

  # Destroy
  test "destroy returns 204" do
    @mock_runner.stub("delete to do id", "")
    delete api_v2_todo_url("T1")
    assert_response :no_content
  end

  # Move
  test "move returns 204" do
    @mock_runner.stub("move to do id", "")
    post move_api_v2_todo_url("T1"), params: { target_list: "Inbox" }, as: :json
    assert_response :no_content
  end

  test "move returns 400 without target_list" do
    post move_api_v2_todo_url("T1"), params: {}, as: :json
    assert_response :bad_request
  end

  # Schedule
  test "schedule returns 204" do
    @mock_runner.stub("schedule to do id", "")
    post schedule_api_v2_todo_url("T1"), params: { date: "2024-01-01" }, as: :json
    assert_response :no_content
  end

  test "schedule returns 400 without date" do
    post schedule_api_v2_todo_url("T1"), params: {}, as: :json
    assert_response :bad_request
  end

  # Complete
  test "complete returns 204" do
    @mock_runner.stub("status of to do id", "")
    post complete_api_v2_todo_url("T1")
    assert_response :no_content
  end

  # Cancel
  test "cancel returns 204" do
    @mock_runner.stub("canceled", "")
    post cancel_api_v2_todo_url("T1")
    assert_response :no_content
  end

  # Show in UI
  test "show_in_ui returns 204" do
    @mock_runner.stub("show to do id", "")
    post show_in_ui_api_v2_todo_url("T1")
    assert_response :no_content
  end

  # Edit
  test "edit returns 204" do
    @mock_runner.stub("edit to do id", "")
    post edit_api_v2_todo_url("T1")
    assert_response :no_content
  end

  # Error handling
  test "returns 503 when Things not running" do
    @mock_runner.stub("to dos", ThingsScript::NotRunningError.new("Things 3 is not running"))
    get api_v2_todos_url
    assert_response :service_unavailable
  end
end
