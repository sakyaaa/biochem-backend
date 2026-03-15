class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string     :title,       null: false
      t.text       :content,     null: false, default: ""
      t.integer    :status,      null: false, default: 0
      t.references :author,      null: false, foreign_key: { to_table: :users }
      t.references :section,     null: true,  foreign_key: true
      t.integer    :views_count, null: false, default: 0

      t.timestamps null: false
    end

    add_index :articles, :status
    add_index :articles, :created_at
    add_index :articles, :views_count
  end
end
