# frozen_string_literal: true

class Article < ApplicationRecord
  include PgSearch::Model

  belongs_to :author, class_name: 'User'
  belongs_to :section, optional: true
  has_many   :comments,    dependent: :destroy
  has_many   :bookmarks,   dependent: :destroy
  has_many   :attachments, dependent: :destroy
  has_many   :view_logs,   dependent: :destroy
  has_and_belongs_to_many :tags

  enum :status, { draft: 0, published: 1 }, default: :draft

  pg_search_scope :search_fulltext,
                  against: { title: 'A', content: 'B' },
                  using: {
                    tsearch: { prefix: true, dictionary: 'russian' },
                    trigram: { threshold: 0.1 }
                  }

  validates :title,   presence: true, length: { maximum: 255 }
  validates :content, presence: true

  scope :published,   -> { where(status: :published) }
  scope :by_section,  ->(section_id) { where(section_id: section_id) }
  scope :popular,     ->(limit = 10) { published.order(views_count: :desc).limit(limit) }
  scope :recent,      ->(limit = 10) { published.order(created_at: :desc).limit(limit) }
  scope :by_tag,      ->(tag_id) { joins(:tags).where(tags: { id: tag_id }) }
  scope :by_author,   ->(author_id) { where(author_id: author_id) }
end
