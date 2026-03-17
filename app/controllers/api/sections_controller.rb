# frozen_string_literal: true

module Api
  class SectionsController < BaseController
    skip_before_action :authenticate_user!

    def index
      counts    = Article.published.group(:section_id).count
      @sections = Section.all.order(:name)
      render json: { data: @sections.map { |s| serialize(s, counts[s.id] || 0) } }
    end

    def show
      @section = Section.find_by!(slug: params[:id])
      render json: { data: serialize(@section) }
    end

    private

    def serialize(section, articles_count = nil)
      {
        id: section.id,
        name: section.name,
        description: section.description,
        slug: section.slug,
        articles_count: articles_count || section.articles.published.count
      }
    end
  end
end
