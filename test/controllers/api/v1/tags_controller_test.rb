require "test_helper"

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_runner = ThingsScript::MockRunner.new
    ThingsScript.runner = @mock_runner
  end

  test "index returns all tags" do
    @mock_runner.stub(/set tagList to tags/, '[{"name":"urgent"},{"name":"home"}]')
    get api_v1_tags_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 2, json.size
  end

  test "create returns 201" do
    @mock_runner.stub(/make new tag/, "")
    post api_v1_tags_url, params: { name: "new-tag" }, as: :json
    assert_response :created
  end

  test "create returns 400 without name" do
    post api_v1_tags_url, params: {}, as: :json
    assert_response :bad_request
  end

  test "destroy returns 204" do
    @mock_runner.stub(/delete tag/, "")
    delete api_v1_tag_url("urgent")
    assert_response :no_content
  end
end
