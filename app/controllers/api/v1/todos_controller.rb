module Api
  module V1
    class TodosController < BaseController
      def index
        render json: ThingsScript::Todos.all
      end

      def show
        render json: ThingsScript::Todos.find(params[:id])
      end

      def create
        validate_name!
        result = ThingsScript::Todos.create(todo_params)
        render json: result, status: :created
      end

      def update
        result = ThingsScript::Todos.update(params[:id], todo_params)
        render json: result
      end

      def destroy
        ThingsScript::Todos.delete(params[:id])
        head :no_content
      end

      def move
        raise ThingsScript::ValidationError, "target_list is required" unless params[:target_list].present?
        ThingsScript::Todos.move(params[:id], target_list: params[:target_list])
        head :no_content
      end

      def schedule
        raise ThingsScript::ValidationError, "date is required" unless params[:date].present?
        ThingsScript::Todos.schedule(params[:id], params[:date])
        head :no_content
      end

      def complete
        ThingsScript::Todos.complete(params[:id])
        head :no_content
      end

      def cancel
        ThingsScript::Todos.cancel(params[:id])
        head :no_content
      end

      def show_in_ui
        ThingsScript::Todos.show(params[:id])
        head :no_content
      end

      def edit
        ThingsScript::Todos.edit(params[:id])
        head :no_content
      end

      private

      def todo_params
        params.permit(:name, :notes, :tag_names, :due_date, :list, :project, :area).to_h.symbolize_keys
      end

      def validate_name!
        raise ThingsScript::ValidationError, "name is required" unless params[:name].present?
      end
    end
  end
end
