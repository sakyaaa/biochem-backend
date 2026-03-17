# frozen_string_literal: true

# Общая логика сериализации статьи.
# Включается в ArticlesController и AuthorsController.
module ArticleSerializer
  # Сериализует одну статью. comments_count можно передать снаружи,
  # чтобы избежать дополнительного SQL-запроса при bulk-операциях.
  def serialize_article(article, comments_count: nil)
    {
      id: article.id,
      title: article.title,
      content: article.content,
      status: article.status,
      views_count: article.views_count,
      created_at: article.created_at,
      updated_at: article.updated_at,
      author: { id: article.author.id, name: article.author.name },
      section: article.section ? { id: article.section.id, name: article.section.name, slug: article.section.slug } : nil,
      tags: article.tags.map { |t| { id: t.id, name: t.name } },
      comments_count: comments_count.nil? ? article.comments.approved.count : comments_count
    }
  end

  # Сериализует коллекцию статей — один SQL-запрос на все comments_count.
  def serialize_articles(articles)
    ids    = articles.map(&:id)
    counts = Comment.approved.where(article_id: ids).group(:article_id).count
    articles.map { |a| serialize_article(a, comments_count: counts[a.id] || 0) }
  end
end
