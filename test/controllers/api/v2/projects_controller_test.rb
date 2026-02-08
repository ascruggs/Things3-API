require "test_helper"

class Api::V2::ProjectsControllerTest < ActionDispatch::IntegrationTest
  # Index
  test "index returns projects" do
    @mock_runner.stub("projects", '[{"id":"P1","name":"Test"}]')
    get api_v2_projects_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end

  # Show
  test "show returns a project" do
    @mock_runner.stub("project id", '{"id":"P1","name":"Test"}')
    get api_v2_project_url("P1")
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "P1", json["id"]
  end

  test "show returns 404 for missing project" do
    @mock_runner.stub("project id", ThingsScript::NotFoundError.new("not found"))
    get api_v2_project_url("MISSING")
    assert_response :not_found
  end

  # Todos
  test "todos returns project todos" do
    @mock_runner.stub("project id", '[{"id":"T1","name":"Test"}]')
    get todos_api_v2_project_url("P1")
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end

  # Create (URL scheme)
  test "create returns 201" do
    post api_v2_projects_url, params: { title: "My Project" }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "My Project", json["title"]
  end

  test "create returns 400 without title" do
    post api_v2_projects_url, params: { notes: "no title" }, as: :json
    assert_response :bad_request
  end

  # Update (URL scheme)
  test "update returns 200" do
    patch api_v2_project_url("P1"), params: { title: "Updated" }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "P1", json["id"]
  end

  test "update returns 401 without auth token" do
    ThingsShortcut.auth_token = nil
    patch api_v2_project_url("P1"), params: { title: "Updated" }, as: :json
    assert_response :unauthorized
  end

  # Destroy
  test "destroy returns 204" do
    @mock_runner.stub("delete project id", "")
    delete api_v2_project_url("P1")
    assert_response :no_content
  end

  # Complete
  test "complete returns 204" do
    @mock_runner.stub("status of project id", "")
    post complete_api_v2_project_url("P1")
    assert_response :no_content
  end

  # Show in UI
  test "show_in_ui returns 204" do
    @mock_runner.stub("show project id", "")
    post show_in_ui_api_v2_project_url("P1")
    assert_response :no_content
  end
end
