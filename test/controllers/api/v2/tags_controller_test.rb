require "test_helper"

class Api::V2::TagsControllerTest < ActionDispatch::IntegrationTest
  test "index returns tags" do
    @mock_runner.stub("tags", '[{"name":"errand"}]')
    get api_v2_tags_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end

  test "create returns 201" do
    @mock_runner.stub("make new tag", "")
    post api_v2_tags_url, params: { name: "errand" }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "errand", json["name"]
  end

  test "create returns 400 without name" do
    post api_v2_tags_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "destroy returns 204" do
    @mock_runner.stub("delete tag", "")
    delete api_v2_tag_url("errand")
    assert_response :no_content
  end

  test "destroy returns 404 for missing tag" do
    @mock_runner.stub("delete tag", ThingsScript::NotFoundError.new("not found"))
    delete api_v2_tag_url("MISSING")
    assert_response :not_found
  end
end
