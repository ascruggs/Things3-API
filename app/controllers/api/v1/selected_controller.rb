module Api
  module V1
    class SelectedController < BaseController
      def index
        render json: ThingsScript::Todos.selected
      end
    end
  end
end
