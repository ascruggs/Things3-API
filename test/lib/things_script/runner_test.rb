require "test_helper"
require "open3"

class ThingsScript::RunnerTest < ActiveSupport::TestCase
  test "raises NotRunningError when Things 3 is not running" do
    runner = ThingsScript::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_script|
      [ "", "application isn't running", Struct.new(:success?).new(false) ]
    end
    assert_raises(ThingsScript::NotRunningError) do
      runner.execute("tell application \"Things3\" to get name")
    end
  end

  test "raises ExecutionError on non-zero exit" do
    runner = ThingsScript::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_script|
      [ "", "some error", Struct.new(:success?).new(false) ]
    end
    assert_raises(ThingsScript::ExecutionError) do
      runner.execute("bad script")
    end
  end

  test "returns stdout on success" do
    runner = ThingsScript::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_script|
      [ "hello world", "", Struct.new(:success?).new(true) ]
    end
    assert_equal "hello world", runner.execute("echo hello")
  end

  test "strips whitespace from stdout" do
    runner = ThingsScript::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_script|
      [ "  result  \n", "", Struct.new(:success?).new(true) ]
    end
    assert_equal "result", runner.execute("some script")
  end
end
