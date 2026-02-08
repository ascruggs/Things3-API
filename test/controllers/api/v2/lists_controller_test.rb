require "test_helper"

class Api::V2::ListsControllerTest < ActionDispatch::IntegrationTest
  test "index returns lists" do
    get api_v2_lists_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
    assert_includes json.map { |l| l["name"] }, "Inbox"
  end

  test "todos returns list todos" do
    @mock_runner.stub("list", '[{"id":"T1","name":"Test"}]')
    get todos_api_v2_list_url("Inbox")
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end
end
