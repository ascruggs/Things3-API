require "test_helper"

class ThingsScript::ScriptBuilderTest < ActiveSupport::TestCase
  test "wrap_tell wraps body in tell block" do
    result = ThingsScript::ScriptBuilder.wrap_tell("get name")
    assert_includes result, 'tell application "Things3"'
    assert_includes result, "get name"
    assert_includes result, "end tell"
  end

  test "with_helpers includes helper functions and tell block" do
    result = ThingsScript::ScriptBuilder.with_helpers("get name")
    assert_includes result, "on jsonEscape"
    assert_includes result, "on dateToISO"
    assert_includes result, 'tell application "Things3"'
  end

  test "sanitize escapes quotes for AppleScript embedding" do
    result = ThingsScript::ScriptBuilder.sanitize('hello "world"')
    assert_includes result, '\\"'
    assert_not_includes result, '""'
  end

  test "sanitize handles nil" do
    assert_equal "", ThingsScript::ScriptBuilder.sanitize(nil)
  end

  test "todo_to_json_expr generates AppleScript for serializing a to-do" do
    result = ThingsScript::ScriptBuilder.todo_to_json_expr("t")
    assert_includes result, "id of t"
    assert_includes result, "name of t"
    assert_includes result, "status of t"
    assert_includes result, "notes of t"
    assert_includes result, "tag names of t"
    assert_includes result, "due date of t"
    assert_includes result, "activation date of t"
    assert_includes result, "contact of t"
    assert_includes result, "project of t"
    assert_includes result, "area of t"
  end

  test "project_to_json_expr generates AppleScript for serializing a project" do
    result = ThingsScript::ScriptBuilder.project_to_json_expr("p")
    assert_includes result, "id of p"
    assert_includes result, "name of p"
    assert_includes result, "status of p"
    assert_includes result, "creation date of p"
    assert_includes result, "modification date of p"
    assert_includes result, "cancellation date of p"
    assert_includes result, "activation date of p"
    assert_includes result, "contact of p"
    assert_includes result, "area of p"
  end

  test "area_to_json_expr generates AppleScript for serializing an area" do
    result = ThingsScript::ScriptBuilder.area_to_json_expr("a")
    assert_includes result, "id of a"
    assert_includes result, "name of a"
    assert_includes result, "tag names of a"
    assert_includes result, "collapsed of a"
  end
end
