require "test_helper"

class ThingsScript::TodosTest < ActiveSupport::TestCase
  test "all returns parsed array of todos" do
    @mock_runner.stub(/set todoList to to dos/, '[{"id":"1","name":"Buy milk","status":"open"}]')
    result = ThingsScript::Todos.all
    assert_equal 1, result.size
    assert_equal "Buy milk", result.first[:name]
  end

  test "find returns single todo" do
    @mock_runner.stub(/to do id "ABC"/, '{"id":"ABC","name":"Test","status":"open"}')
    result = ThingsScript::Todos.find("ABC")
    assert_equal "ABC", result[:id]
  end

  test "find raises NotFoundError when todo not found" do
    @mock_runner.stub(/to do id/, "")
    assert_raises(ThingsScript::NotFoundError) do
      ThingsScript::Todos.find("missing-id")
    end
  end

  test "in_list generates correct script" do
    @mock_runner.stub(/to dos of list "Inbox"/, "[]")
    ThingsScript::Todos.in_list("Inbox")
    assert @mock_runner.executed_scripts.last.include?('list "Inbox"')
  end

  test "in_project generates correct script" do
    @mock_runner.stub(/to dos of project id "P1"/, "[]")
    ThingsScript::Todos.in_project("P1")
    assert @mock_runner.executed_scripts.last.include?('project id "P1"')
  end

  test "in_area generates correct script" do
    @mock_runner.stub(/to dos of area id "A1"/, "[]")
    ThingsScript::Todos.in_area("A1")
    assert @mock_runner.executed_scripts.last.include?('area id "A1"')
  end

  test "create generates make new to do script" do
    @mock_runner.stub(/make new to do/, '{"id":"NEW","name":"Task","status":"open"}')
    result = ThingsScript::Todos.create(name: "Task")
    assert_equal "NEW", result[:id]
    assert @mock_runner.executed_scripts.last.include?("make new to do")
  end

  test "create with list moves todo" do
    @mock_runner.stub(/make new to do/, '{"id":"NEW","name":"Task","status":"open"}')
    ThingsScript::Todos.create(name: "Task", list: "Today")
    assert @mock_runner.executed_scripts.last.include?('move newTodo to list "Today"')
  end

  test "update generates set property scripts" do
    @mock_runner.stub(/set name of t/, '{"id":"1","name":"Updated","status":"open"}')
    result = ThingsScript::Todos.update("1", name: "Updated")
    assert_equal "Updated", result[:name]
  end

  test "delete generates delete script" do
    @mock_runner.stub(/delete to do id "1"/, "")
    assert ThingsScript::Todos.delete("1")
  end

  test "move generates move script" do
    @mock_runner.stub(/move to do id "1"/, "")
    assert ThingsScript::Todos.move("1", target_list: "Today")
    assert @mock_runner.executed_scripts.last.include?('list "Today"')
  end

  test "complete generates set status script" do
    @mock_runner.stub(/set status.*completed/, "")
    assert ThingsScript::Todos.complete("1")
  end

  test "cancel generates set status script" do
    @mock_runner.stub(/set status.*canceled/, "")
    assert ThingsScript::Todos.cancel("1")
  end

  test "show generates show script" do
    @mock_runner.stub(/show to do id/, "")
    assert ThingsScript::Todos.show("1")
  end

  test "edit generates edit script" do
    @mock_runner.stub(/edit to do id/, "")
    assert ThingsScript::Todos.edit("1")
  end
end
