module ThingsShortcut
  class MockShortcutRunner
    attr_reader :executed_urls

    def initialize
      @executed_urls = []
    end

    def execute(url)
      @executed_urls << url
      true
    end

    def reset!
      @executed_urls.clear
      self
    end
  end
end
