module Api
  module V2
    class RootController < BaseController
      def index
        render json: {
          api: "Things 3 API",
          version: "v2",
          description: "Full CRUD API with URL Scheme writes and AppleScript reads",
          endpoints: {
            todos: "/api/v2/todos",
            projects: "/api/v2/projects",
            areas: "/api/v2/areas",
            tags: "/api/v2/tags",
            lists: "/api/v2/lists",
            selected: "/api/v2/selected",
            search: "/api/v2/search",
            version: "/api/v2/version",
            json: "/api/v2/json",
            empty_trash: "/api/v2/empty_trash",
            log_completed: "/api/v2/log_completed",
            quick_entry: "/api/v2/quick_entry"
          }
        }
      end
    end
  end
end
