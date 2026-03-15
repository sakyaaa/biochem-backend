class Section < ApplicationRecord
  has_many :articles, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/, message: "только строчные буквы, цифры и дефис" }
end
