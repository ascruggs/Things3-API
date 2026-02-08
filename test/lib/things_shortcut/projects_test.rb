require "test_helper"

class ThingsShortcut::ProjectsTest < ActiveSupport::TestCase
  # URL scheme: add
  test "add builds correct URL and returns params" do
    result = ThingsShortcut::Projects.add(title: "My Project")
    assert_equal({ title: "My Project" }, result)
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///add-project"
    assert_includes @mock_shortcut_runner.executed_urls.last, "title=My+Project"
  end

  test "add raises ValidationError without title" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::Projects.add(notes: "no title")
    end
  end

  # URL scheme: update
  test "update builds correct URL with auth token" do
    result = ThingsShortcut::Projects.update("P1", title: "Updated Project")
    assert_equal "P1", result[:id]
    assert_equal "Updated Project", result[:title]
    assert_nil result[:auth_token]
    assert_includes @mock_shortcut_runner.executed_urls.last, "things:///update-project"
    assert_includes @mock_shortcut_runner.executed_urls.last, "auth-token=test-token"
  end

  test "update raises AuthTokenError without auth token" do
    ThingsShortcut.auth_token = nil
    assert_raises(ThingsShortcut::AuthTokenError) do
      ThingsShortcut::Projects.update("P1", title: "Updated")
    end
  end

  # AppleScript reads (delegated via ErrorMapper)
  test "all delegates to ThingsScript::Projects.all" do
    @mock_runner.stub("projects", '[{"id":"P1","name":"Test"}]')
    result = ThingsShortcut::Projects.all
    assert_instance_of Array, result
  end

  test "find delegates to ThingsScript::Projects.find" do
    @mock_runner.stub("project id", '{"id":"P1","name":"Test"}')
    result = ThingsShortcut::Projects.find("P1")
    assert_instance_of Hash, result
  end

  test "todos delegates to ThingsScript::Projects.todos" do
    @mock_runner.stub("project id", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Projects.todos("P1")
    assert_instance_of Array, result
  end

  # AppleScript actions (delegated via ErrorMapper)
  test "delete delegates to ThingsScript::Projects.delete" do
    @mock_runner.stub("delete project id", "")
    result = ThingsShortcut::Projects.delete("P1")
    assert_equal true, result
  end

  test "complete delegates to ThingsScript::Projects.complete" do
    @mock_runner.stub("status of project id", "")
    result = ThingsShortcut::Projects.complete("P1")
    assert_equal true, result
  end

  test "show delegates to ThingsScript::Projects.show" do
    @mock_runner.stub("show project id", "")
    result = ThingsShortcut::Projects.show("P1")
    assert_equal true, result
  end
end
