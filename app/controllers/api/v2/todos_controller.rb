module Api
  module V2
    class TodosController < BaseController
      def index
        render json: ThingsShortcut::Todos.all
      end

      def show
        render json: ThingsShortcut::Todos.find(params[:id])
      end

      def create
        result = ThingsShortcut::Todos.add(todo_params)
        render json: result, status: :created
      end

      def update
        result = ThingsShortcut::Todos.update(params[:id], todo_params)
        render json: result
      end

      def destroy
        ThingsShortcut::Todos.delete(params[:id])
        head :no_content
      end

      def move
        raise ThingsShortcut::ValidationError, "target_list is required" unless params[:target_list].present?
        ThingsShortcut::Todos.move(params[:id], target_list: params[:target_list])
        head :no_content
      end

      def schedule
        raise ThingsShortcut::ValidationError, "date is required" unless params[:date].present?
        ThingsShortcut::Todos.schedule(params[:id], params[:date])
        head :no_content
      end

      def complete
        ThingsShortcut::Todos.complete(params[:id])
        head :no_content
      end

      def cancel
        ThingsShortcut::Todos.cancel(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsShortcut::Todos.show(params[:id])
        head :no_content
      end

      def edit
        ThingsShortcut::Todos.edit(params[:id])
        head :no_content
      end

      private

      def todo_params
        params.permit(
          :title, :titles, :notes, :when, :deadline, :tags,
          :checklist_items, :list, :list_id, :heading, :heading_id,
          :completed, :canceled, :show_quick_entry, :reveal,
          :creation_date, :completion_date,
          :prepend_notes, :append_notes, :add_tags,
          :prepend_checklist_items, :append_checklist_items,
          :duplicate
        ).to_h.symbolize_keys
      end
    end
  end
end
