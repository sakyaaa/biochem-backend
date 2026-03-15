class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string :name,        null: false
      t.text   :description
      t.string :slug,        null: false

      t.timestamps null: false
    end
    add_index :sections, :slug, unique: true
  end
end
