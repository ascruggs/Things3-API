module Api
  module V2
    class BaseController < ApplicationController
      rescue_from ThingsShortcut::NotRunningError do |e|
        render json: { error: e.message }, status: :service_unavailable
      end

      rescue_from ThingsShortcut::NotFoundError do |e|
        render json: { error: e.message }, status: :not_found
      end

      rescue_from ThingsShortcut::ValidationError do |e|
        render json: { error: e.message }, status: :bad_request
      end

      rescue_from ThingsShortcut::AuthTokenError do |e|
        render json: { error: e.message }, status: :unauthorized
      end

      rescue_from ThingsShortcut::ExecutionError do |e|
        render json: { error: e.message }, status: :unprocessable_entity
      end

      rescue_from ThingsShortcut::ParseError do |e|
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end
end
