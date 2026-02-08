module ThingsShortcut
  class Error < StandardError; end
  class ExecutionError < Error; end
  class NotRunningError < Error; end
  class NotFoundError < Error; end
  class ParseError < Error; end
  class ValidationError < Error; end
  class AuthTokenError < Error; end

  mattr_accessor :runner, default: Runner.new
  mattr_accessor :auth_token, default: ENV["THINGS_AUTH_TOKEN"]
end
