require "test_helper"

class ThingsShortcut::TagsTest < ActiveSupport::TestCase
  test "all delegates to ThingsScript::Tags.all" do
    @mock_runner.stub("tags", '[{"name":"errand"}]')
    result = ThingsShortcut::Tags.all
    assert_instance_of Array, result
  end

  test "create delegates to ThingsScript::Tags.create" do
    @mock_runner.stub("make new tag", "")
    result = ThingsShortcut::Tags.create("errand")
    assert_equal({ name: "errand" }, result)
  end

  test "create with parent_tag" do
    @mock_runner.stub("make new tag", "")
    result = ThingsShortcut::Tags.create("sub", parent_tag: "parent")
    assert_equal({ name: "sub", parent_tag: "parent" }, result)
  end

  test "delete delegates to ThingsScript::Tags.delete" do
    @mock_runner.stub("delete tag", "")
    result = ThingsShortcut::Tags.delete("errand")
    assert_equal true, result
  end

end
