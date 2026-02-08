module Api
  module V1
    class ListsController < BaseController
      def index
        render json: ThingsScript::Lists.all
      end

      def todos
        render json: ThingsScript::Todos.in_list(params[:name])
      end
    end
  end
end
