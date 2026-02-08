module Api
  module V2
    class ProjectsController < BaseController
      def index
        render json: ThingsShortcut::Projects.all
      end

      def show
        render json: ThingsShortcut::Projects.find(params[:id])
      end

      def todos
        render json: ThingsShortcut::Projects.todos(params[:id])
      end

      def create
        result = ThingsShortcut::Projects.add(project_params)
        render json: result, status: :created
      end

      def update
        result = ThingsShortcut::Projects.update(params[:id], project_params)
        render json: result
      end

      def destroy
        ThingsShortcut::Projects.delete(params[:id])
        head :no_content
      end

      def complete
        ThingsShortcut::Projects.complete(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsShortcut::Projects.show(params[:id])
        head :no_content
      end

      private

      def project_params
        params.permit(
          :title, :notes, :when, :deadline, :tags, :area, :area_id,
          :to_dos, :completed, :canceled, :reveal,
          :creation_date, :completion_date,
          :prepend_notes, :append_notes, :add_tags, :duplicate
        ).to_h.symbolize_keys
      end
    end
  end
end
