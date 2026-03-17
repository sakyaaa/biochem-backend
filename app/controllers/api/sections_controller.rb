# frozen_string_literal: true

module Api
  class SectionsController < BaseController
    skip_before_action :authenticate_user!

    def index
      @sections = Section.all.order(:name)
      render json: { data: @sections.map { |s| serialize(s) } }
    end

    def show
      @section = Section.find_by!(slug: params[:id])
      render json: { data: serialize(@section) }
    end

    private

    def serialize(section)
      {
        id: section.id,
        name: section.name,
        description: section.description,
        slug: section.slug,
        articles_count: section.articles.published.count
      }
    end
  end
end
