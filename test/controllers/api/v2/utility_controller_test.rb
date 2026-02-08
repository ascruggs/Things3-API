require "test_helper"

class Api::V2::UtilityControllerTest < ActionDispatch::IntegrationTest
  test "version returns 200" do
    get api_v2_version_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "ok", json["status"]
  end

  test "json_import returns 201" do
    post api_v2_json_url, params: { data: '[{"type":"to-do","attributes":{"title":"Test"}}]' }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert json.key?("data")
  end
end
