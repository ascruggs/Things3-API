ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "support/mock_runner"
require_relative "support/mock_shortcut_runner"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    setup do
      @mock_runner = ThingsScript::MockRunner.new
      ThingsScript.runner = @mock_runner

      @mock_shortcut_runner = ThingsShortcut::MockShortcutRunner.new
      ThingsShortcut.runner = @mock_shortcut_runner
      @original_auth_token = ThingsShortcut.auth_token
      ThingsShortcut.auth_token = "test-token"
    end

    teardown do
      ThingsScript.runner = ThingsScript::Runner.new
      ThingsShortcut.runner = ThingsShortcut::Runner.new
      ThingsShortcut.auth_token = @original_auth_token
    end
  end
end
