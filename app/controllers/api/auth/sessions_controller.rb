module Api
  module Auth
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
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
        if current_user
          render json: { message: "Выход выполнен успешно" }, status: :ok
        else
          render json: { message: "Нет активной сессии" }, status: :unauthorized
        end
      end
    end
  end
end
