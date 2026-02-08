require "test_helper"

class Api::V1::RootControllerTest < ActionDispatch::IntegrationTest
  test "index returns API discovery" do
    get api_v1_root_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Things 3 API", json["api"]
    assert_equal "v1", json["version"]
    assert json["endpoints"].key?("todos")
    assert json["endpoints"].key?("projects")
    assert json["endpoints"].key?("areas")
    assert json["endpoints"].key?("tags")
    assert json["endpoints"].key?("lists")
    assert json["endpoints"].key?("selected")
  end
end
