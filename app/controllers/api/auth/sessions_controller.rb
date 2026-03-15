module Api
  module Auth
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        # Devise-JWT помещает токен в заголовок Authorization ответа —
        # перекладываем его в httpOnly cookie, чтобы JS не мог его прочитать
        token = response.headers["Authorization"]&.delete_prefix("Bearer ")
        if token.present?
          cookies[:jwt_token] = {
            value:     token,
            httponly:  true,
            same_site: :strict,
            secure:    Rails.env.production?,
            expires:   24.hours.from_now
          }
        end

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
        cookies.delete(:jwt_token)
        render json: { message: "Выход выполнен успешно" }, status: :ok
      end
    end
  end
end
