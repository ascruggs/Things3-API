require "test_helper"

class ThingsShortcut::ActionsTest < ActiveSupport::TestCase
  # URL scheme
  test "empty_trash uses URL scheme" do
    result = ThingsShortcut::Actions.empty_trash
    assert_equal true, result
    assert_equal "things:///empty-trash", @mock_shortcut_runner.executed_urls.last
  end

  # AppleScript
  test "log_completed delegates to ThingsScript::Actions" do
    @mock_runner.stub("log completed", "")
    result = ThingsShortcut::Actions.log_completed
    assert_equal true, result
  end

  test "quick_entry delegates to ThingsScript::Actions" do
    @mock_runner.stub("quick entry", "")
    result = ThingsShortcut::Actions.quick_entry
    assert_equal true, result
  end

  test "quick_entry with params delegates to ThingsScript::Actions" do
    @mock_runner.stub("quick entry", "")
    result = ThingsShortcut::Actions.quick_entry(name: "Test")
    assert_equal true, result
  end
end
