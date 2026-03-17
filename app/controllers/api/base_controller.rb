# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    include ActionController::Cookies
    include Pundit::Authorization

    before_action :set_locale
    before_action :inject_jwt_from_cookie
    before_action :authenticate_user!

    rescue_from Pundit::NotAuthorizedError,        with: :render_forbidden
    rescue_from ActiveRecord::RecordNotFound,      with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid,       with: :render_unprocessable
    rescue_from ActionController::ParameterMissing, with: :render_bad_request

    private

    def current_user
      @current_user ||= warden.authenticate(scope: :api_user)
    end

    def authenticate_user!
      render json: { error: 'Необходима авторизация' }, status: :unauthorized unless current_user
    end

    def set_locale
      lang = cookies[:lang]
      I18n.locale = lang == 'en' ? :en : :ru
    end

    def inject_jwt_from_cookie
      return if request.headers['Authorization'].present?

      token = cookies[:jwt_token]
      request.headers['Authorization'] = "Bearer #{token}" if token.present?
    end

    def render_forbidden
      render json: { error: 'Доступ запрещён' }, status: :forbidden
    end

    def render_not_found
      render json: { error: 'Запись не найдена' }, status: :not_found
    end

    def render_unprocessable(e)
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    def render_bad_request(e)
      render json: { error: e.message }, status: :bad_request
    end

    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value
      }
    end
  end
end
