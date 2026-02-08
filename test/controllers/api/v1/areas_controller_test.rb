require "test_helper"

class Api::V1::AreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns all areas" do
    @mock_runner.stub(/set areaList to areas/, '[{"id":"A1","name":"Work"}]')
    get api_v1_areas_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size
  end

  test "show returns single area" do
    @mock_runner.stub(/area id "A1"/, '{"id":"A1","name":"Work"}')
    get api_v1_area_url("A1")
    assert_response :success
  end

  test "show returns 404 for missing area" do
    @mock_runner.stub(/area id/, "")
    get api_v1_area_url("missing")
    assert_response :not_found
  end

  test "todos returns todos in area" do
    @mock_runner.stub(/to dos of area id "A1"/, '[{"id":"1","name":"Task","status":"open"}]')
    get todos_api_v1_area_url("A1")
    assert_response :success
  end

  test "projects returns projects in area" do
    @mock_runner.stub(/projects of area id "A1"/, '[{"id":"P1","name":"Proj","status":"open"}]')
    get projects_api_v1_area_url("A1")
    assert_response :success
  end

  test "create returns 201" do
    @mock_runner.stub(/make new area/, '{"id":"A2","name":"Personal"}')
    post api_v1_areas_url, params: { name: "Personal" }, as: :json
    assert_response :created
  end

  test "create returns 400 without name" do
    post api_v1_areas_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "update returns updated area" do
    @mock_runner.stub(/set name of a/, '{"id":"A1","name":"Updated"}')
    patch api_v1_area_url("A1"), params: { name: "Updated" }, as: :json
    assert_response :success
  end

  test "destroy returns 204" do
    @mock_runner.stub(/delete area id/, "")
    delete api_v1_area_url("A1")
    assert_response :no_content
  end

  test "show_in_ui returns 204" do
    @mock_runner.stub(/show area id/, "")
    post show_in_ui_api_v1_area_url("A1")
    assert_response :no_content
  end
end
