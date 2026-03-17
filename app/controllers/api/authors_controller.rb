# frozen_string_literal: true

module Api
  class AuthorsController < BaseController
    include ::ArticleSerializer

    skip_before_action :authenticate_user!

    def show
      @user = User.find(params[:id])
      render json: {
        data: {
          id: @user.id,
          name: @user.name,
          role: @user.role
        }
      }
    end

    def articles
      @user = User.find(params[:author_id])
      @articles = Article.published.by_author(@user.id)
                         .includes(:author, :section, :tags)
                         .order(created_at: :desc)
                         .page(params[:page]).per(20)
      render json: {
        data: serialize_articles(@articles),
        meta: pagination_meta(@articles)
      }
    end
  end
end
