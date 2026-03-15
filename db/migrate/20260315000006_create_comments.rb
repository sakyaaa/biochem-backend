class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.text       :body,    null: false
      t.boolean    :approved, null: false, default: false

      t.timestamps null: false
    end
    add_index :comments, :approved
  end
end
