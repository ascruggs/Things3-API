require "test_helper"

class ThingsShortcut::RunnerTest < ActiveSupport::TestCase
  test "returns true on success" do
    runner = ThingsShortcut::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_url|
      [ "", "", Struct.new(:success?).new(true) ]
    end
    assert_equal true, runner.execute("things:///version")
  end

  test "raises NotRunningError when Things 3 is not running" do
    runner = ThingsShortcut::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_url|
      [ "", "application isn't running", Struct.new(:success?).new(false) ]
    end
    assert_raises(ThingsShortcut::NotRunningError) do
      runner.execute("things:///version")
    end
  end

  test "raises ExecutionError on non-zero exit" do
    runner = ThingsShortcut::Runner.new
    runner.define_singleton_method(:execute_capture3) do |_url|
      [ "", "some error", Struct.new(:success?).new(false) ]
    end
    assert_raises(ThingsShortcut::ExecutionError) do
      runner.execute("things:///version")
    end
  end
end
