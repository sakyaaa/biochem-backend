# frozen_string_literal: true

module Api
  class TagsController < BaseController
    skip_before_action :authenticate_user!

    def index
      @tags = Tag.left_joins(:articles)
                 .select('tags.*, COUNT(articles.id) AS articles_count')
                 .group('tags.id').order('articles_count DESC, tags.name ASC')
      render json: { data: @tags.map { |t| { id: t.id, name: t.name, articles_count: t.articles_count } } }
    end

    def show
      @tag = Tag.find(params[:id])
      render json: { data: { id: @tag.id, name: @tag.name } }
    end
  end
end
