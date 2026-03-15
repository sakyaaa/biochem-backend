module Api
  class ArticlesController < BaseController
    skip_before_action :authenticate_user!, only: %i[index show]
    before_action :set_article, only: %i[show update destroy]

    def index
      @articles = base_scope

      if params[:q].present?
        @articles = Article.published.search_fulltext(params[:q])
      elsif params[:section_id].present?
        @articles = @articles.by_section(params[:section_id])
      end

      @articles = @articles.includes(:author, :section, :tags)
                            .page(params[:page]).per(params[:per_page] || 20)

      render json: {
        data: serialize_collection(@articles),
        meta: pagination_meta(@articles)
      }
    end

    def show
      ViewLog.create(user: current_user, article: @article)
      Article.where(id: @article.id).update_all("views_count = views_count + 1")
      render json: { data: serialize_resource(@article.reload) }
    end

    def create
      authorize Article
      @article = current_user.articles.build(article_params)
      if @article.save
        render json: { data: serialize_resource(@article) }, status: :created
      else
        render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize @article
      if @article.update(article_params)
        render json: { data: serialize_resource(@article) }
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
      Article.published.order(created_at: :desc)
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :status, :section_id, tag_ids: [])
    end

    def serialize_resource(article)
      {
        id:          article.id,
        title:       article.title,
        content:     article.content,
        status:      article.status,
        views_count: article.views_count,
        created_at:  article.created_at,
        updated_at:  article.updated_at,
        author:      { id: article.author.id, name: article.author.name },
        section:     article.section ? { id: article.section.id, name: article.section.name, slug: article.section.slug } : nil,
        tags:        article.tags.map { |t| { id: t.id, name: t.name } }
      }
    end

    def serialize_collection(articles)
      articles.map { |a| serialize_resource(a) }
    end
  end
end
