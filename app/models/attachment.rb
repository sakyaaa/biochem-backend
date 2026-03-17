# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :article

  validates :filename,     presence: true
  validates :content_type, presence: true

  ALLOWED_TYPES = %w[image/jpeg image/png image/gif image/webp application/pdf].freeze

  validates :content_type, inclusion: { in: ALLOWED_TYPES, message: 'тип файла не разрешён' }
end
