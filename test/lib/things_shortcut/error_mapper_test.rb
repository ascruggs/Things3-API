require "test_helper"

class ThingsShortcut::ErrorMapperTest < ActiveSupport::TestCase
  test "maps NotRunningError" do
    assert_raises(ThingsShortcut::NotRunningError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::NotRunningError, "not running" }
    end
  end

  test "maps NotFoundError" do
    assert_raises(ThingsShortcut::NotFoundError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::NotFoundError, "not found" }
    end
  end

  test "maps ExecutionError" do
    assert_raises(ThingsShortcut::ExecutionError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::ExecutionError, "exec error" }
    end
  end

  test "maps ParseError" do
    assert_raises(ThingsShortcut::ParseError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::ParseError, "parse error" }
    end
  end

  test "maps ValidationError" do
    assert_raises(ThingsShortcut::ValidationError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::ValidationError, "validation" }
    end
  end

  test "preserves error message" do
    error = assert_raises(ThingsShortcut::NotFoundError) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::NotFoundError, "To-do not found: ABC" }
    end
    assert_equal "To-do not found: ABC", error.message
  end

  test "returns block value on success" do
    result = ThingsShortcut::ErrorMapper.wrap { 42 }
    assert_equal 42, result
  end

  test "maps unknown ThingsScript::Error to ThingsShortcut::Error" do
    assert_raises(ThingsShortcut::Error) do
      ThingsShortcut::ErrorMapper.wrap { raise ThingsScript::Error, "unknown" }
    end
  end
end
