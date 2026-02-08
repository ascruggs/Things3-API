module ThingsShortcut
  module Todos
    module_function

    # URL scheme: create
    def add(params)
      unless params[:title] || params[:titles]
        raise ValidationError, "title or titles is required"
      end

      url = UrlBuilder.build("add", params)
      ThingsShortcut.runner.execute(url)
      params
    end

    # URL scheme: update
    def update(id, params)
      raise AuthTokenError, "auth-token is required for update" unless ThingsShortcut.auth_token

      merged = params.merge(id: id, auth_token: ThingsShortcut.auth_token)
      url = UrlBuilder.build("update", merged)
      ThingsShortcut.runner.execute(url)
      merged.except(:auth_token)
    end

    # AppleScript reads
    def all
      ErrorMapper.wrap { ThingsScript::Todos.all }
    end

    def find(id)
      ErrorMapper.wrap { ThingsScript::Todos.find(id) }
    end

    def in_list(name)
      ErrorMapper.wrap { ThingsScript::Todos.in_list(name) }
    end

    def in_project(id)
      ErrorMapper.wrap { ThingsScript::Todos.in_project(id) }
    end

    def in_area(id)
      ErrorMapper.wrap { ThingsScript::Todos.in_area(id) }
    end

    def selected
      ErrorMapper.wrap { ThingsScript::Todos.selected }
    end

    # AppleScript actions
    def delete(id)
      ErrorMapper.wrap { ThingsScript::Todos.delete(id) }
    end

    def move(id, target_list:)
      ErrorMapper.wrap { ThingsScript::Todos.move(id, target_list: target_list) }
    end

    def schedule(id, date)
      ErrorMapper.wrap { ThingsScript::Todos.schedule(id, date) }
    end

    def complete(id)
      ErrorMapper.wrap { ThingsScript::Todos.complete(id) }
    end

    def cancel(id)
      ErrorMapper.wrap { ThingsScript::Todos.cancel(id) }
    end

    def show(id)
      ErrorMapper.wrap { ThingsScript::Todos.show(id) }
    end

    def edit(id)
      ErrorMapper.wrap { ThingsScript::Todos.edit(id) }
    end
  end
end
