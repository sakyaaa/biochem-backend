class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum :role, { guest: 0, member: 1, editor: 2, admin: 3 }, default: :guest

  has_many :articles, foreign_key: :author_id, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_articles, through: :bookmarks, source: :article
  has_many :view_logs, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }

  def editor_or_admin?
    editor? || admin?
  end
end
