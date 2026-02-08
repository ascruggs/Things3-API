require "test_helper"

class Api::V1::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns all projects" do
    @mock_runner.stub(/set projList to projects/, '[{"id":"P1","name":"Work","status":"open"}]')
    get api_v1_projects_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size
  end

  test "show returns single project" do
    @mock_runner.stub(/project id "P1"/, '{"id":"P1","name":"Work","status":"open"}')
    get api_v1_project_url("P1")
    assert_response :success
  end

  test "show returns 404 for missing project" do
    @mock_runner.stub(/project id/, "")
    get api_v1_project_url("missing")
    assert_response :not_found
  end

  test "todos returns todos in project" do
    @mock_runner.stub(/to dos of project id "P1"/, '[{"id":"1","name":"Task","status":"open"}]')
    get todos_api_v1_project_url("P1")
    assert_response :success
  end

  test "create returns 201" do
    @mock_runner.stub(/make new project/, '{"id":"P2","name":"New","status":"open"}')
    post api_v1_projects_url, params: { name: "New" }, as: :json
    assert_response :created
  end

  test "create returns 400 without name" do
    post api_v1_projects_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "update returns updated project" do
    @mock_runner.stub(/set name of p/, '{"id":"P1","name":"Updated","status":"open"}')
    patch api_v1_project_url("P1"), params: { name: "Updated" }, as: :json
    assert_response :success
  end

  test "destroy returns 204" do
    @mock_runner.stub(/delete project id/, "")
    delete api_v1_project_url("P1")
    assert_response :no_content
  end

  test "complete returns 204" do
    @mock_runner.stub(/set status.*completed/, "")
    post complete_api_v1_project_url("P1")
    assert_response :no_content
  end

  test "show_in_ui returns 204" do
    @mock_runner.stub(/show project id/, "")
    post show_in_ui_api_v1_project_url("P1")
    assert_response :no_content
  end
end
