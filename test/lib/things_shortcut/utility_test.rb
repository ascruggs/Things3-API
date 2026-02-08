require "test_helper"

class ThingsShortcut::UtilityTest < ActiveSupport::TestCase
  test "version builds correct URL" do
    result = ThingsShortcut::Utility.version
    assert_equal({}, result)
    assert_equal "things:///version", @mock_shortcut_runner.executed_urls.last
  end

  test "json_import with string data builds correct URL" do
    data = '[{"type":"to-do","attributes":{"title":"Test"}}]'
    result = ThingsShortcut::Utility.json_import(data)
    assert_equal data, result[:data]
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///json"
  end

  test "json_import with hash data serializes to JSON" do
    data = [{ type: "to-do", attributes: { title: "Test" } }]
    result = ThingsShortcut::Utility.json_import(data)
    assert_equal data.to_json, result[:data]
  end

  test "json_import includes auth token in URL when available" do
    ThingsShortcut::Utility.json_import("[]")
    assert_includes @mock_shortcut_runner.executed_urls.last, "auth-token=test-token"
  end

  test "json_import omits auth token from result" do
    result = ThingsShortcut::Utility.json_import("[]")
    assert_nil result[:auth_token]
  end

  test "json_import includes reveal param" do
    result = ThingsShortcut::Utility.json_import("[]", reveal: "true")
    assert_equal "true", result[:reveal]
  end

end
