module Api
  module V1
    class ActionsController < BaseController
      def empty_trash
        ThingsScript::Actions.empty_trash
        head :no_content
      end

      def log_completed
        ThingsScript::Actions.log_completed
        head :no_content
      end

      def quick_entry
        ThingsScript::Actions.quick_entry(
          params.permit(:name, :notes, :autofill).to_h.symbolize_keys
        )
        head :no_content
      end
    end
  end
end
