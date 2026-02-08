require "test_helper"

class Api::V2::NavigationControllerTest < ActionDispatch::IntegrationTest
  test "search returns 200 with query" do
    get api_v2_search_url, params: { query: "groceries" }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "groceries", json["query"]
  end

  test "search returns 400 without query" do
    get api_v2_search_url
    assert_response :bad_request
  end
end
