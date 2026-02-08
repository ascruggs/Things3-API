require "test_helper"

class ThingsScript::ProjectsTest < ActiveSupport::TestCase
  test "all returns parsed array of projects" do
    @mock_runner.stub(/set projList to projects/, '[{"id":"P1","name":"My Project","status":"open"}]')
    result = ThingsScript::Projects.all
    assert_equal 1, result.size
    assert_equal "My Project", result.first[:name]
  end

  test "find returns single project" do
    @mock_runner.stub(/project id "P1"/, '{"id":"P1","name":"My Project","status":"open"}')
    result = ThingsScript::Projects.find("P1")
    assert_equal "P1", result[:id]
  end

  test "find raises NotFoundError when not found" do
    @mock_runner.stub(/project id/, "")
    assert_raises(ThingsScript::NotFoundError) do
      ThingsScript::Projects.find("missing")
    end
  end

  test "todos delegates to Todos.in_project" do
    @mock_runner.stub(/to dos of project id "P1"/, "[]")
    result = ThingsScript::Projects.todos("P1")
    assert_equal [], result
  end

  test "create generates make new project script" do
    @mock_runner.stub(/make new project/, '{"id":"P2","name":"New","status":"open"}')
    result = ThingsScript::Projects.create(name: "New")
    assert_equal "P2", result[:id]
  end

  test "update generates set property scripts" do
    @mock_runner.stub(/set name of p/, '{"id":"P1","name":"Updated","status":"open"}')
    result = ThingsScript::Projects.update("P1", name: "Updated")
    assert_equal "Updated", result[:name]
  end

  test "delete generates delete script" do
    @mock_runner.stub(/delete project id "P1"/, "")
    assert ThingsScript::Projects.delete("P1")
  end

  test "complete generates set status script" do
    @mock_runner.stub(/set status.*completed/, "")
    assert ThingsScript::Projects.complete("P1")
  end

  test "show generates show script" do
    @mock_runner.stub(/show project id/, "")
    assert ThingsScript::Projects.show("P1")
  end
end
