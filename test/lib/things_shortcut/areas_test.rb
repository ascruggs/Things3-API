require "test_helper"

class ThingsShortcut::AreasTest < ActiveSupport::TestCase
  test "all delegates to ThingsScript::Areas.all" do
    @mock_runner.stub("areas", '[{"id":"A1","name":"Work"}]')
    result = ThingsShortcut::Areas.all
    assert_instance_of Array, result
  end

  test "find delegates to ThingsScript::Areas.find" do
    @mock_runner.stub("area id", '{"id":"A1","name":"Work"}')
    result = ThingsShortcut::Areas.find("A1")
    assert_instance_of Hash, result
  end

  test "todos delegates to ThingsScript::Areas.todos" do
    @mock_runner.stub("area id", '[{"id":"T1","name":"Test"}]')
    result = ThingsShortcut::Areas.todos("A1")
    assert_instance_of Array, result
  end

  test "projects delegates to ThingsScript::Areas.projects" do
    @mock_runner.stub("area id", '[{"id":"P1","name":"Test"}]')
    result = ThingsShortcut::Areas.projects("A1")
    assert_instance_of Array, result
  end

  test "create delegates to ThingsScript::Areas.create" do
    @mock_runner.stub("make new area", '{"id":"A2","name":"Personal"}')
    result = ThingsShortcut::Areas.create(name: "Personal")
    assert_instance_of Hash, result
  end

  test "update delegates to ThingsScript::Areas.update" do
    @mock_runner.stub("area id", '{"id":"A1","name":"Updated"}')
    result = ThingsShortcut::Areas.update("A1", name: "Updated")
    assert_instance_of Hash, result
  end

  test "delete delegates to ThingsScript::Areas.delete" do
    @mock_runner.stub("delete area id", "")
    result = ThingsShortcut::Areas.delete("A1")
    assert_equal true, result
  end

  test "show delegates to ThingsScript::Areas.show" do
    @mock_runner.stub("show area id", "")
    result = ThingsShortcut::Areas.show("A1")
    assert_equal true, result
  end

end
