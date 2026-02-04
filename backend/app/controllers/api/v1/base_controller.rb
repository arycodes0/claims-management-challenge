module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: { error: e.message }, status: :not_found
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def authenticate_user!
        token = request.headers["Authorization"]&.split(" ")&.last
        @current_user = User.find_by(authentication_token: token)
        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
