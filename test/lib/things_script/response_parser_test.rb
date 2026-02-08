require "test_helper"

class ThingsScript::ResponseParserTest < ActiveSupport::TestCase
  test "parse returns hash from valid JSON object" do
    result = ThingsScript::ResponseParser.parse('{"id":"123","name":"Test"}')
    assert_equal({ id: "123", name: "Test" }, result)
  end

  test "parse returns nil for empty string" do
    assert_nil ThingsScript::ResponseParser.parse("")
  end

  test "parse returns nil for nil" do
    assert_nil ThingsScript::ResponseParser.parse(nil)
  end

  test "parse returns nil for missing value" do
    assert_nil ThingsScript::ResponseParser.parse("missing value")
  end

  test "parse raises ParseError for invalid JSON" do
    assert_raises(ThingsScript::ParseError) do
      ThingsScript::ResponseParser.parse("{invalid json}")
    end
  end

  test "parse_array returns array from valid JSON array" do
    result = ThingsScript::ResponseParser.parse_array('[{"id":"1"},{"id":"2"}]')
    assert_equal [ { id: "1" }, { id: "2" } ], result
  end

  test "parse_array returns empty array for empty string" do
    assert_equal [], ThingsScript::ResponseParser.parse_array("")
  end

  test "parse_array wraps single object in array" do
    result = ThingsScript::ResponseParser.parse_array('{"id":"1"}')
    assert_equal [ { id: "1" } ], result
  end

  test "parse_array raises ParseError for invalid JSON" do
    assert_raises(ThingsScript::ParseError) do
      ThingsScript::ResponseParser.parse_array("{invalid}")
    end
  end
end
