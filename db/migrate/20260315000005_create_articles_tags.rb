# frozen_string_literal: true

class CreateArticlesTags < ActiveRecord::Migration[8.0]
  def change
    create_table :articles_tags, id: false do |t|
      t.references :article, null: false, foreign_key: true
      t.references :tag,     null: false, foreign_key: true
    end
    add_index :articles_tags, %i[article_id tag_id], unique: true
  end
end
