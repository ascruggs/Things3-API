module Api
  module V2
    class TagsController < BaseController
      def index
        render json: ThingsShortcut::Tags.all
      end

      def create
        raise ThingsShortcut::ValidationError, "name is required" unless params[:name].present?
        result = ThingsShortcut::Tags.create(params[:name], parent_tag: params[:parent_tag])
        render json: result, status: :created
      end

      def destroy
        ThingsShortcut::Tags.delete(params[:name])
        head :no_content
      end
    end
  end
end
