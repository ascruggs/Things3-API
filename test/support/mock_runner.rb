module ThingsScript
  class MockRunner
    attr_reader :executed_scripts

    def initialize(responses = {})
      @responses = responses
      @executed_scripts = []
    end

    def execute(script)
      @executed_scripts << script

      @responses.each do |pattern, response|
        if pattern.is_a?(Regexp)
          return response if script.match?(pattern)
        elsif script.include?(pattern.to_s)
          return response
        end
      end

      ""
    end

    def stub(pattern, response)
      @responses[pattern] = response
      self
    end

    def reset!
      @executed_scripts.clear
      @responses.clear
      self
    end
  end
end
