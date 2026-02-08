module Api
  module V1
    class AreasController < BaseController
      def index
        render json: ThingsScript::Areas.all
      end

      def show
        render json: ThingsScript::Areas.find(params[:id])
      end

      def todos
        render json: ThingsScript::Areas.todos(params[:id])
      end

      def projects
        render json: ThingsScript::Areas.projects(params[:id])
      end

      def create
        validate_name!
        result = ThingsScript::Areas.create(area_params)
        render json: result, status: :created
      end

      def update
        result = ThingsScript::Areas.update(params[:id], area_params)
        render json: result
      end

      def destroy
        ThingsScript::Areas.delete(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsScript::Areas.show(params[:id])
        head :no_content
      end

      private

      def area_params
        params.permit(:name, :tag_names).to_h.symbolize_keys
      end

      def validate_name!
        raise ThingsScript::ValidationError, "name is required" unless params[:name].present?
      end
    end
  end
end
