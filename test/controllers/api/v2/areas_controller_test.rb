require "test_helper"

class Api::V2::AreasControllerTest < ActionDispatch::IntegrationTest
  test "index returns areas" do
    @mock_runner.stub("areas", '[{"id":"A1","name":"Work"}]')
    get api_v2_areas_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end

  test "show returns an area" do
    @mock_runner.stub("area id", '{"id":"A1","name":"Work"}')
    get api_v2_area_url("A1")
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "A1", json["id"]
  end

  test "show returns 404 for missing area" do
    @mock_runner.stub("area id", ThingsScript::NotFoundError.new("not found"))
    get api_v2_area_url("MISSING")
    assert_response :not_found
  end

  test "todos returns area todos" do
    @mock_runner.stub("area id", '[{"id":"T1","name":"Test"}]')
    get todos_api_v2_area_url("A1")
    assert_response :success
  end

  test "projects returns area projects" do
    @mock_runner.stub("area id", '[{"id":"P1","name":"Test"}]')
    get projects_api_v2_area_url("A1")
    assert_response :success
  end

  test "create returns 201" do
    @mock_runner.stub("make new area", '{"id":"A2","name":"Personal"}')
    post api_v2_areas_url, params: { name: "Personal" }, as: :json
    assert_response :created
  end

  test "create returns 400 without name" do
    post api_v2_areas_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "update returns 200" do
    @mock_runner.stub("area id", '{"id":"A1","name":"Updated"}')
    patch api_v2_area_url("A1"), params: { name: "Updated" }, as: :json
    assert_response :success
  end

  test "destroy returns 204" do
    @mock_runner.stub("delete area id", "")
    delete api_v2_area_url("A1")
    assert_response :no_content
  end

  test "show_in_ui returns 204" do
    @mock_runner.stub("show area id", "")
    post show_in_ui_api_v2_area_url("A1")
    assert_response :no_content
  end
end
