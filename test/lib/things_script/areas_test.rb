require "test_helper"

class ThingsScript::AreasTest < ActiveSupport::TestCase
  test "all returns parsed array of areas" do
    @mock_runner.stub(/set areaList to areas/, '[{"id":"A1","name":"Work"}]')
    result = ThingsScript::Areas.all
    assert_equal 1, result.size
    assert_equal "Work", result.first[:name]
  end

  test "find returns single area" do
    @mock_runner.stub(/area id "A1"/, '{"id":"A1","name":"Work"}')
    result = ThingsScript::Areas.find("A1")
    assert_equal "A1", result[:id]
  end

  test "find raises NotFoundError when not found" do
    @mock_runner.stub(/area id/, "")
    assert_raises(ThingsScript::NotFoundError) do
      ThingsScript::Areas.find("missing")
    end
  end

  test "todos delegates to Todos.in_area" do
    @mock_runner.stub(/to dos of area id "A1"/, "[]")
    result = ThingsScript::Areas.todos("A1")
    assert_equal [], result
  end

  test "projects returns projects in area" do
    @mock_runner.stub(/projects of area id "A1"/, '[{"id":"P1","name":"Proj","status":"open"}]')
    result = ThingsScript::Areas.projects("A1")
    assert_equal 1, result.size
  end

  test "create generates make new area script" do
    @mock_runner.stub(/make new area/, '{"id":"A2","name":"Personal"}')
    result = ThingsScript::Areas.create(name: "Personal")
    assert_equal "A2", result[:id]
  end

  test "update generates set property scripts" do
    @mock_runner.stub(/set name of a/, '{"id":"A1","name":"Updated"}')
    result = ThingsScript::Areas.update("A1", name: "Updated")
    assert_equal "Updated", result[:name]
  end

  test "delete generates delete script" do
    @mock_runner.stub(/delete area id "A1"/, "")
    assert ThingsScript::Areas.delete("A1")
  end

  test "show generates show script" do
    @mock_runner.stub(/show area id/, "")
    assert ThingsScript::Areas.show("A1")
  end
end
