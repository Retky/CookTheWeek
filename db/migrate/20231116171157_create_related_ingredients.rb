class CreateRelatedIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :related_ingredients do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.float :quantity
      t.string :unit

      t.timestamps
    end
  end
end
