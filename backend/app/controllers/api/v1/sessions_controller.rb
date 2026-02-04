module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = user.generate_token!
          render json: { token: token, user: { id: user.id, email: user.email, role: user.role } }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def destroy
        current_user.invalidate_token!
        render json: { message: "Logged out" }
      end
    end
  end
end
