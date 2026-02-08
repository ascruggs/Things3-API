require "test_helper"

class Api::V1::TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns all todos" do
    @mock_runner.stub(/set todoList to to dos/, '[{"id":"1","name":"Test","status":"open"}]')
    get api_v1_todos_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size
    assert_equal "Test", json.first["name"]
  end

  test "show returns single todo" do
    @mock_runner.stub(/to do id "ABC"/, '{"id":"ABC","name":"Test","status":"open"}')
    get api_v1_todo_url("ABC")
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "ABC", json["id"]
  end

  test "show returns 404 for missing todo" do
    @mock_runner.stub(/to do id/, "")
    get api_v1_todo_url("missing")
    assert_response :not_found
  end

  test "create returns 201 with todo" do
    @mock_runner.stub(/make new to do/, '{"id":"NEW","name":"Buy milk","status":"open"}')
    post api_v1_todos_url, params: { name: "Buy milk" }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "Buy milk", json["name"]
  end

  test "create returns 400 without name" do
    post api_v1_todos_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "update returns updated todo" do
    @mock_runner.stub(/set name of t/, '{"id":"1","name":"Updated","status":"open"}')
    patch api_v1_todo_url("1"), params: { name: "Updated" }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated", json["name"]
  end

  test "destroy returns 204" do
    @mock_runner.stub(/delete to do id/, "")
    delete api_v1_todo_url("1")
    assert_response :no_content
  end

  test "move returns 204" do
    @mock_runner.stub(/move to do id/, "")
    post move_api_v1_todo_url("1"), params: { target_list: "Today" }, as: :json
    assert_response :no_content
  end

  test "move returns 400 without target_list" do
    post move_api_v1_todo_url("1"), params: {}, as: :json
    assert_response :bad_request
  end

  test "schedule returns 204" do
    @mock_runner.stub(/schedule to do id/, "")
    post schedule_api_v1_todo_url("1"), params: { date: "2024-01-15" }, as: :json
    assert_response :no_content
  end

  test "schedule returns 400 without date" do
    post schedule_api_v1_todo_url("1"), params: {}, as: :json
    assert_response :bad_request
  end

  test "complete returns 204" do
    @mock_runner.stub(/set status.*completed/, "")
    post complete_api_v1_todo_url("1")
    assert_response :no_content
  end

  test "cancel returns 204" do
    @mock_runner.stub(/set status.*canceled/, "")
    post cancel_api_v1_todo_url("1")
    assert_response :no_content
  end

  test "show_in_ui returns 204" do
    @mock_runner.stub(/show to do id/, "")
    post show_in_ui_api_v1_todo_url("1")
    assert_response :no_content
  end

  test "edit returns 204" do
    @mock_runner.stub(/edit to do id/, "")
    post edit_api_v1_todo_url("1")
    assert_response :no_content
  end

  test "returns 503 when Things not running" do
    @mock_runner.define_singleton_method(:execute) do |script|
      raise ThingsScript::NotRunningError, "Things 3 is not running"
    end
    get api_v1_todos_url
    assert_response :service_unavailable
    json = JSON.parse(response.body)
    assert_equal "Things 3 is not running", json["error"]
  end
end
