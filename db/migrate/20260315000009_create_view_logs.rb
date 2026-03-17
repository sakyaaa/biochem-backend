# frozen_string_literal: true

class CreateViewLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :view_logs do |t|
      t.references :user,    null: true,  foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.datetime   :created_at, null: false
    end
    add_index :view_logs, :created_at
  end
end
