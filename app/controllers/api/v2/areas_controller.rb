module Api
  module V2
    class AreasController < BaseController
      def index
        render json: ThingsShortcut::Areas.all
      end

      def show
        render json: ThingsShortcut::Areas.find(params[:id])
      end

      def todos
        render json: ThingsShortcut::Areas.todos(params[:id])
      end

      def projects
        render json: ThingsShortcut::Areas.projects(params[:id])
      end

      def create
        validate_name!
        result = ThingsShortcut::Areas.create(area_params)
        render json: result, status: :created
      end

      def update
        result = ThingsShortcut::Areas.update(params[:id], area_params)
        render json: result
      end

      def destroy
        ThingsShortcut::Areas.delete(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsShortcut::Areas.show(params[:id])
        head :no_content
      end

      private

      def area_params
        params.permit(:name, :tag_names).to_h.symbolize_keys
      end

      def validate_name!
        raise ThingsShortcut::ValidationError, "name is required" unless params[:name].present?
      end
    end
  end
end
