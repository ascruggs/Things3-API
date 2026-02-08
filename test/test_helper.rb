ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "support/mock_runner"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    setup do
      @mock_runner = ThingsScript::MockRunner.new
      ThingsScript.runner = @mock_runner
    end

    teardown do
      ThingsScript.runner = ThingsScript::Runner.new
    end
  end
end
