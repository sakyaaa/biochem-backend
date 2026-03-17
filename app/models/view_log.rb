# frozen_string_literal: true

class ViewLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :article

  def self.count_by_period(from:, to:)
    where(created_at: from..to).count
  end
end
