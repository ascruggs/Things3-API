module Api
  module V1
    class TagsController < BaseController
      def index
        render json: ThingsScript::Tags.all
      end

      def create
        raise ThingsScript::ValidationError, "name is required" unless params[:name].present?
        result = ThingsScript::Tags.create(params[:name], parent_tag: params[:parent_tag])
        render json: result, status: :created
      end

      def destroy
        ThingsScript::Tags.delete(params[:name])
        head :no_content
      end
    end
  end
end
