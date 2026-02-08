require "test_helper"

class Api::V2::SelectedControllerTest < ActionDispatch::IntegrationTest
  test "index returns selected todos" do
    @mock_runner.stub("selected to dos", '[{"id":"T1","name":"Test"}]')
    get api_v2_selected_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_instance_of Array, json
  end
end
