module Api
  module Auth
    class SessionsController < Devise::SessionsController
      include ActionController::Cookies
      respond_to :json

      private

      def respond_with(_resource, _opts = {})
        # warden.user(:user) возвращает аутентифицированного пользователя в API-режиме
        resource = warden.user(:api_user) || _resource
        render json: {
          data: {
            id:    resource.id,
            name:  resource.name,
            email: resource.email,
            role:  resource.role
          },
          message: "Вход выполнен успешно"
        }, status: :ok
      end

      def respond_to_on_destroy
        # JWT middleware убирает кукe через revocation; дополнительно удалём её здесь
        cookies.delete(:jwt_token)
        render json: { message: "Выход выполнен успешно" }, status: :ok
      end
    end
  end
end
