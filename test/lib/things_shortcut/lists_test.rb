require "test_helper"

class ThingsShortcut::ListsTest < ActiveSupport::TestCase
  test "all returns built-in list names" do
    result = ThingsShortcut::Lists.all
    assert_instance_of Array, result
    assert_includes result.map { |l| l[:name] }, "Inbox"
    assert_includes result.map { |l| l[:name] }, "Today"
  end
end
