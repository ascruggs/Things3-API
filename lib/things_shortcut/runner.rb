require "open3"
require "timeout"

module ThingsShortcut
  class Runner
    TIMEOUT = 30

    def execute(url)
      _stdout, stderr, status = Timeout.timeout(TIMEOUT) do
        execute_capture3(url)
      end

      unless status.success?
        if stderr.include?("application isn't running") || stderr.include?("Application isn't running")
          raise NotRunningError, "Things 3 is not running"
        end
        raise ExecutionError, stderr.strip
      end

      true
    rescue Timeout::Error
      raise ExecutionError, "URL scheme execution timed out after #{TIMEOUT} seconds"
    end

    private

    def execute_capture3(url)
      Open3.capture3("open", url)
    end
  end
end
