class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :recipe_id
      t.date :day
      t.integer :portions

      t.timestamps
    end
  end
end
