# frozen_string_literal: true

module Api
  class AuthorsController < BaseController
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
                         .includes(:author, :section, :tags, :comments)
                         .order(created_at: :desc)
                         .page(params[:page]).per(20)
      render json: {
        data: @articles.map { |a| serialize_article(a) },
        meta: pagination_meta(@articles)
      }
    end

    private

    def serialize_article(article)
      {
        id: article.id,
        title: article.title,
        content: article.content,
        status: article.status,
        views_count: article.views_count,
        comments_count: article.comments.approved.count,
        created_at: article.created_at,
        updated_at: article.updated_at,
        author: { id: article.author.id, name: article.author.name },
        section: article.section ? { id: article.section.id, name: article.section.name, slug: article.section.slug } : nil,
        tags: article.tags.map { |t| { id: t.id, name: t.name } }
      }
    end
  end
end
