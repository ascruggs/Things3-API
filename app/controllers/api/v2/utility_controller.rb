module Api
  module V2
    class UtilityController < BaseController
      def version
        ThingsShortcut::Utility.version
        render json: { status: "ok" }
      end

      def json_import
        result = ThingsShortcut::Utility.json_import(
          params[:data],
          reveal: params[:reveal]
        )
        render json: result, status: :created
      end
    end
  end
end
