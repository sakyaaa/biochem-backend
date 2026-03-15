class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :body, presence: true, length: { minimum: 5, maximum: 2000 }

  scope :approved, -> { where(approved: true) }
  scope :pending,  -> { where(approved: false) }
end
