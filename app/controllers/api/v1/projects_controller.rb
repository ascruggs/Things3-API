module Api
  module V1
    class ProjectsController < BaseController
      def index
        render json: ThingsScript::Projects.all
      end

      def show
        render json: ThingsScript::Projects.find(params[:id])
      end

      def todos
        render json: ThingsScript::Projects.todos(params[:id])
      end

      def create
        validate_name!
        result = ThingsScript::Projects.create(project_params)
        render json: result, status: :created
      end

      def update
        result = ThingsScript::Projects.update(params[:id], project_params)
        render json: result
      end

      def destroy
        ThingsScript::Projects.delete(params[:id])
        head :no_content
      end

      def complete
        ThingsScript::Projects.complete(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsScript::Projects.show(params[:id])
        head :no_content
      end

      private

      def project_params
        params.permit(:name, :notes, :tag_names, :due_date).to_h.symbolize_keys
      end

      def validate_name!
        raise ThingsScript::ValidationError, "name is required" unless params[:name].present?
      end
    end
  end
end
