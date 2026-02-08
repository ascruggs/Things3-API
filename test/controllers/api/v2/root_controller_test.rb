require "test_helper"

class Api::V2::RootControllerTest < ActionDispatch::IntegrationTest
  test "index returns API discovery" do
    get api_v2_root_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Things 3 API", json["api"]
    assert_equal "v2", json["version"]
    assert json["endpoints"].key?("todos")
    assert json["endpoints"].key?("projects")
    assert json["endpoints"].key?("areas")
    assert json["endpoints"].key?("tags")
    assert json["endpoints"].key?("lists")
    assert json["endpoints"].key?("selected")
    assert json["endpoints"].key?("search")
    assert json["endpoints"].key?("version")
    assert json["endpoints"].key?("json")
    assert json["endpoints"].key?("empty_trash")
    assert json["endpoints"].key?("log_completed")
    assert json["endpoints"].key?("quick_entry")
  end
end
