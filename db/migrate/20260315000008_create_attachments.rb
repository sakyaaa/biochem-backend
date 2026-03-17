# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :article,      null: false, foreign_key: true
      t.string     :filename,     null: false
      t.string     :content_type, null: false
      t.bigint     :byte_size,    null: false, default: 0

      t.timestamps null: false
    end
  end
end
