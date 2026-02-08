require "open3"
require "timeout"

module ThingsScript
  class Runner
    TIMEOUT = 30

    def execute(script)
      stdout, stderr, status = Timeout.timeout(TIMEOUT) do
        execute_capture3(script)
      end

      unless status.success?
        if stderr.include?("application isn't running") || stderr.include?("Application isn't running")
          raise NotRunningError, "Things 3 is not running"
        end
        raise ExecutionError, stderr.strip
      end

      stdout.strip
    rescue Timeout::Error
      raise ExecutionError, "AppleScript execution timed out after #{TIMEOUT} seconds"
    end

    private

    def execute_capture3(script)
      Open3.capture3("osascript", "-e", script)
    end
  end
end
