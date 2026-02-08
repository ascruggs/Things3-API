module Api
  module V2
    class ActionsController < BaseController
      def empty_trash
        ThingsShortcut::Actions.empty_trash
        head :no_content
      end

      def log_completed
        ThingsShortcut::Actions.log_completed
        head :no_content
      end

      def quick_entry
        ThingsShortcut::Actions.quick_entry(
          params.permit(:name, :notes, :autofill).to_h.symbolize_keys
        )
        head :no_content
      end
    end
  end
end
