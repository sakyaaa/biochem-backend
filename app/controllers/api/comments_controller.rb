# frozen_string_literal: true

module Api
  class CommentsController < BaseController
    skip_before_action :authenticate_user!, only: :index
    before_action :set_article

    def index
      @comments = @article.comments.approved.includes(:user).order(created_at: :asc)
      render json: {
        data: @comments.map do |c|
          { id: c.id, body: c.body, created_at: c.created_at,
            user: { id: c.user.id, name: c.user.name } }
        end
      }
    end

    def create
      @comment = @article.comments.build(comment_params.merge(user: current_user))
      if @comment.save
        render json: {
          data: { id: @comment.id, body: @comment.body, created_at: @comment.created_at,
                  approved: @comment.approved,
                  user: { id: current_user.id, name: current_user.name } }
        }, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_article
      @article = Article.published.find(params[:article_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
