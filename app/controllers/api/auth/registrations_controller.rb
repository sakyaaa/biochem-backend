module Api
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      before_action :configure_permitted_parameters

      private

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      end

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            data: { id: resource.id, name: resource.name, email: resource.email, role: resource.role },
            message: "Регистрация выполнена успешно"
          }, status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
