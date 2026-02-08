require "test_helper"

class ThingsScript::TagsTest < ActiveSupport::TestCase
  test "all returns parsed array of tags" do
    @mock_runner.stub(/set tagList to tags/, '[{"name":"urgent"},{"name":"home","parent_tag":"personal"}]')
    result = ThingsScript::Tags.all
    assert_equal 2, result.size
    assert_equal "urgent", result.first[:name]
    assert_equal "personal", result.last[:parent_tag]
  end

  test "create returns tag hash" do
    @mock_runner.stub(/make new tag/, "")
    result = ThingsScript::Tags.create("urgent")
    assert_equal({ name: "urgent" }, result)
  end

  test "create with parent_tag includes parent in script" do
    @mock_runner.stub(/make new tag/, "")
    result = ThingsScript::Tags.create("sub", parent_tag: "parent")
    assert_equal({ name: "sub", parent_tag: "parent" }, result)
    assert @mock_runner.executed_scripts.last.include?('parent tag:tag "parent"')
  end

  test "delete generates delete script" do
    @mock_runner.stub(/delete tag/, "")
    assert ThingsScript::Tags.delete("urgent")
  end

  test "delete raises NotFoundError when not found" do
    @mock_runner.define_singleton_method(:execute) do |script|
      raise ThingsScript::ExecutionError, "Can't get tag"
    end
    assert_raises(ThingsScript::NotFoundError) do
      ThingsScript::Tags.delete("missing")
    end
  end
end
