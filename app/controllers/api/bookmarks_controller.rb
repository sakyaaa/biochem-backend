# frozen_string_literal: true

module Api
  class BookmarksController < BaseController
    def index
      @bookmarks = current_user.bookmarks.includes(:article).order(created_at: :desc)
      render json: {
        data: @bookmarks.map do |b|
          { id: b.id, article: { id: b.article.id, title: b.article.title } }
        end
      }
    end

    def create
      @bookmark = current_user.bookmarks.build(article_id: params[:article_id])
      if @bookmark.save
        render json: { data: { id: @bookmark.id } }, status: :created
      else
        render json: { errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @bookmark = current_user.bookmarks.find(params[:id])
      @bookmark.destroy
      head :no_content
    end
  end
end
