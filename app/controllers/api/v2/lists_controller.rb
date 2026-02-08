module Api
  module V2
    class ListsController < BaseController
      def index
        render json: ThingsShortcut::Lists.all
      end

      def todos
        render json: ThingsShortcut::Todos.in_list(params[:name])
      end
    end
  end
end
