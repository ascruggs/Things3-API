module ThingsScript
  class Error < StandardError; end
  class ExecutionError < Error; end
  class NotRunningError < Error; end
  class NotFoundError < Error; end
  class ParseError < Error; end
  class ValidationError < Error; end

  mattr_accessor :runner, default: Runner.new
end
