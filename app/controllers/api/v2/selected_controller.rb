module Api
  module V2
    class SelectedController < BaseController
      def index
        render json: ThingsShortcut::Todos.selected
      end
    end
  end
end
