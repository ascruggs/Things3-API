module ThingsShortcut
  module Projects
    module_function

    # URL scheme: create
    def add(params)
      raise ValidationError, "title is required" unless params[:title]

      url = UrlBuilder.build("add-project", params)
      ThingsShortcut.runner.execute(url)
      params
    end

    # URL scheme: update
    def update(id, params)
      raise AuthTokenError, "auth-token is required for update" unless ThingsShortcut.auth_token

      merged = params.merge(id: id, auth_token: ThingsShortcut.auth_token)
      url = UrlBuilder.build("update-project", merged)
      ThingsShortcut.runner.execute(url)
      merged.except(:auth_token)
    end

    # AppleScript reads
    def all
      ErrorMapper.wrap { ThingsScript::Projects.all }
    end

    def find(id)
      ErrorMapper.wrap { ThingsScript::Projects.find(id) }
    end

    def todos(id)
      ErrorMapper.wrap { ThingsScript::Projects.todos(id) }
    end

    # AppleScript actions
    def delete(id)
      ErrorMapper.wrap { ThingsScript::Projects.delete(id) }
    end

    def complete(id)
      ErrorMapper.wrap { ThingsScript::Projects.complete(id) }
    end

    def show(id)
      ErrorMapper.wrap { ThingsScript::Projects.show(id) }
    end
  end
end
