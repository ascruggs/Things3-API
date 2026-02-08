module ThingsShortcut
  module Tags
    module_function

    def all
      ErrorMapper.wrap { ThingsScript::Tags.all }
    end

    def create(name, parent_tag: nil)
      ErrorMapper.wrap { ThingsScript::Tags.create(name, parent_tag: parent_tag) }
    end

    def delete(name)
      ErrorMapper.wrap { ThingsScript::Tags.delete(name) }
    end
  end
end
