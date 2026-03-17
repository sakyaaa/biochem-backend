# frozen_string_literal: true

module Api
  class ArticlesController < BaseController
    include ArticleSerializer

    skip_before_action :authenticate_user!, only: %i[index show]
    before_action :set_article, only: %i[show update destroy]

    def index
      @articles = base_scope

      if params[:q].present?
        @articles = Article.published.search_fulltext(params[:q])
      elsif params[:section_id].present?
        @articles = @articles.by_section(params[:section_id])
      end

      @articles = @articles.by_tag(params[:tag_id])       if params[:tag_id].present?
      @articles = @articles.by_author(params[:author_id]) if params[:author_id].present?
      @articles = @articles.where(status: params[:status]) if params[:status].present? && Article.statuses.key?(params[:status])

      @articles = case params[:sort]
                  when 'views'  then @articles.reorder(views_count: :desc)
                  when 'oldest' then @articles.reorder(created_at: :asc)
                  else @articles
                  end

      @articles = @articles.includes(:author, :section, :tags)
                           .page(params[:page]).per(params[:per_page] || 20)

      render json: {
        data: serialize_articles(@articles),
        meta: pagination_meta(@articles)
      }
    end

    def show
      ViewLog.create(user: current_user, article: @article)
      Article.where(id: @article.id).update_all('views_count = views_count + 1')
      @article.reload
      render json: { data: serialize_article(@article) }
    end

    def create
      authorize Article
      @article = current_user.articles.build(article_params)
      if @article.save
        render json: { data: serialize_article(@article, comments_count: 0) }, status: :created
      else
        render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize @article
      if @article.update(article_params)
        render json: { data: serialize_article(@article) }
      else
        render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @article
      @article.destroy
      head :no_content
    end

    private

    def base_scope
      if params[:own].present? && current_user&.editor_or_admin?
        current_user.admin? ? Article.order(created_at: :desc) : current_user.articles.order(created_at: :desc)
      else
        Article.published.order(created_at: :desc)
      end
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :status, :section_id, tag_ids: [])
    end
  end
end
