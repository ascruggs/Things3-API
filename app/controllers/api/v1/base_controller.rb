module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ThingsScript::NotRunningError do |e|
        render json: { error: e.message }, status: :service_unavailable
      end

      rescue_from ThingsScript::NotFoundError do |e|
        render json: { error: e.message }, status: :not_found
      end

      rescue_from ThingsScript::ExecutionError do |e|
        render json: { error: e.message }, status: :unprocessable_entity
      end

      rescue_from ThingsScript::ParseError do |e|
        render json: { error: e.message }, status: :internal_server_error
      end

      rescue_from ThingsScript::ValidationError do |e|
        render json: { error: e.message }, status: :bad_request
      end
    end
  end
end
