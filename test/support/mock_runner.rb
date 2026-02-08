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
        matched = pattern.is_a?(Regexp) ? script.match?(pattern) : script.include?(pattern.to_s)
        if matched
          raise response if response.is_a?(Exception)
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
