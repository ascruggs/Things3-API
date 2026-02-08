module Api
  module V1
    class RootController < BaseController
      def index
        render json: {
          api: "Things 3 API",
          version: "v1",
          endpoints: {
            lists: "/api/v1/lists",
            todos: "/api/v1/todos",
            projects: "/api/v1/projects",
            areas: "/api/v1/areas",
            tags: "/api/v1/tags",
            selected: "/api/v1/selected",
            empty_trash: "/api/v1/empty_trash",
            log_completed: "/api/v1/log_completed",
            quick_entry: "/api/v1/quick_entry"
          }
        }
      end
    end
  end
end
