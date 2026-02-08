module Api
  module V2
    class NavigationController < BaseController
      def search
        result = ThingsShortcut::Navigation.search(params[:query])
        render json: result
      end
    end
  end
end
