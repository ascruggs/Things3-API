module ThingsShortcut
  module Actions
    module_function

    # URL scheme
    def empty_trash
      url = UrlBuilder.build("empty-trash")
      ThingsShortcut.runner.execute(url)
      true
    end

    # AppleScript
    def log_completed
      ErrorMapper.wrap { ThingsScript::Actions.log_completed }
    end

    # AppleScript
    def quick_entry(params = {})
      ErrorMapper.wrap { ThingsScript::Actions.quick_entry(params) }
    end
  end
end
