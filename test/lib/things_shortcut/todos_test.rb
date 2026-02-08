require "test_helper"

class ThingsShortcut::TodosTest < ActiveSupport::TestCase
  # URL scheme: add
  test "add builds correct URL and returns params" do
    result = ThingsShortcut::Todos.add(title: "Buy milk")
    assert_equal({ title: "Buy milk" }, result)
    assert_equal 1, @mock_shortcut_runner.executed_urls.size
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///add"
    assert_includes @mock_shortcut_runner.executed_urls.last, "title=Buy+milk"
  end

  test "add with titles param works" do
    result = ThingsShortcut::Todos.add(titles: "Task 1\nTask 2")
    assert_equal({ titles: "Task 1\nTask 2" }, result)
  end

  test "add raises ValidationError without title or titles" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::Todos.add(notes: "no title")
    end
  end

  # URL scheme: update
  test "update builds correct URL with auth token" do
    result = ThingsShortcut::Todos.update("ABC", title: "Updated")
    assert_equal "ABC", result[:id]
    assert_equal "Updated", result[:title]
    assert_nil result[:auth_token]
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///update"
    assert_includes @mock_shortcut_runner.executed_urls.last, "auth-token=test-token"
  end

  test "update raises AuthTokenError without auth token" do
    ThingsShortcut.auth_token = nil
    assert_raises(ThingsShortcut::AuthTokenError) do
      ThingsShortcut::Todos.update("ABC", title: "Updated")
    end
  end

  # AppleScript reads (delegated via ErrorMapper)
  test "all delegates to ThingsScript::Todos.all" do
    @mock_runner.stub("to dos", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Todos.all
    assert_instance_of Array, result
  end

  test "find delegates to ThingsScript::Todos.find" do
    @mock_runner.stub("to do id", '{"id":"T1","name":"Test"}')
    result = ThingsShortcut::Todos.find("T1")
    assert_instance_of Hash, result
  end

  test "in_list delegates to ThingsScript::Todos.in_list" do
    @mock_runner.stub("list", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Todos.in_list("Inbox")
    assert_instance_of Array, result
  end

  test "in_project delegates to ThingsScript::Todos.in_project" do
    @mock_runner.stub("project id", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Todos.in_project("P1")
    assert_instance_of Array, result
  end

  test "in_area delegates to ThingsScript::Todos.in_area" do
    @mock_runner.stub("area id", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Todos.in_area("A1")
    assert_instance_of Array, result
  end

  test "selected delegates to ThingsScript::Todos.selected" do
    @mock_runner.stub("selected to dos", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Todos.selected
    assert_instance_of Array, result
  end

  # AppleScript actions (delegated via ErrorMapper)
  test "delete delegates to ThingsScript::Todos.delete" do
    @mock_runner.stub("delete to do id", "")
    result = ThingsShortcut::Todos.delete("T1")
    assert_equal true, result
  end

  test "move delegates to ThingsScript::Todos.move" do
    @mock_runner.stub("move to do id", "")
    result = ThingsShortcut::Todos.move("T1", target_list: "Inbox")
    assert_equal true, result
  end

  test "schedule delegates to ThingsScript::Todos.schedule" do
    @mock_runner.stub("schedule to do id", "")
    result = ThingsShortcut::Todos.schedule("T1", "2024-01-01")
    assert_equal true, result
  end

  test "complete delegates to ThingsScript::Todos.complete" do
    @mock_runner.stub("status of to do id", "")
    result = ThingsShortcut::Todos.complete("T1")
    assert_equal true, result
  end

  test "cancel delegates to ThingsScript::Todos.cancel" do
    @mock_runner.stub("canceled", "")
    result = ThingsShortcut::Todos.cancel("T1")
    assert_equal true, result
  end

  test "show delegates to ThingsScript::Todos.show" do
    @mock_runner.stub("show to do id", "")
    result = ThingsShortcut::Todos.show("T1")
    assert_equal true, result
  end

  test "edit delegates to ThingsScript::Todos.edit" do
    @mock_runner.stub("edit to do id", "")
    result = ThingsShortcut::Todos.edit("T1")
    assert_equal true, result
  end
end
