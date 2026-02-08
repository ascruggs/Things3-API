module ThingsShortcut
  module Areas
    module_function

    def all
      ErrorMapper.wrap { ThingsScript::Areas.all }
    end

    def find(id)
      ErrorMapper.wrap { ThingsScript::Areas.find(id) }
    end

    def todos(id)
      ErrorMapper.wrap { ThingsScript::Areas.todos(id) }
    end

    def projects(id)
      ErrorMapper.wrap { ThingsScript::Areas.projects(id) }
    end

    def create(params)
      ErrorMapper.wrap { ThingsScript::Areas.create(params) }
    end

    def update(id, params)
      ErrorMapper.wrap { ThingsScript::Areas.update(id, params) }
    end

    def delete(id)
      ErrorMapper.wrap { ThingsScript::Areas.delete(id) }
    end

    def show(id)
      ErrorMapper.wrap { ThingsScript::Areas.show(id) }
    end
  end
end
