require "json"

module ThingsScript
  module ResponseParser
    module_function

    def parse(json_string)
      return nil if json_string.nil? || json_string.empty? || json_string == "missing value"
      result = JSON.parse(json_string, symbolize_names: true)
      result.is_a?(Hash) ? result : nil
    rescue JSON::ParserError => e
      raise ParseError, "Failed to parse response: #{e.message}"
    end

    def parse_array(json_string)
      return [] if json_string.nil? || json_string.empty? || json_string == "missing value"
      result = JSON.parse(json_string, symbolize_names: true)
      result.is_a?(Array) ? result : [ result ]
    rescue JSON::ParserError => e
      raise ParseError, "Failed to parse response: #{e.message}"
    end
  end
end
