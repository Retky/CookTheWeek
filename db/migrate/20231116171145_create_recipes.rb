class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :portions
      t.integer :difficulty
      t.float :preparation_time
      t.float :cooking_time
      t.boolean :public
      t.text :tips
      t.string :image_url

      t.timestamps
    end
  end
end
