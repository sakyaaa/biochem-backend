# frozen_string_literal: true

module Api
  module Auth
    class SessionsController < Devise::SessionsController
      include ActionController::Cookies

      respond_to :json

      def create
        user = warden.authenticate(scope: :api_user)
        if user
          sign_in(:api_user, user)
          render json: {
            data: { id: user.id, name: user.name, email: user.email, role: user.role },
            message: 'Вход выполнен успешно'
          }, status: :ok
        else
          render json: { error: I18n.t('devise.failure.invalid') }, status: :unauthorized
        end
      end

      def destroy
        cookies.delete(:jwt_token)
        sign_out(:api_user)
        render json: { message: 'Выход выполнен успешно' }, status: :ok
      end
    end
  end
end
