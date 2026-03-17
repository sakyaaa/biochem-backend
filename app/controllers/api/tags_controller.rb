# frozen_string_literal: true

module Api
  class TagsController < BaseController
    skip_before_action :authenticate_user!

    def index
      @tags = Tag.joins(:articles).where(articles: { status: :published })
                 .select('tags.*, COUNT(articles.id) AS articles_count')
                 .group('tags.id').order('articles_count DESC')
      render json: { data: @tags.map { |t| { id: t.id, name: t.name, articles_count: t.articles_count } } }
    end
  end
end
