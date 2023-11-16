class CreateShopListIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_list_ingredients do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :shop_list, null: false, foreign_key: true
      t.float :quantity
      t.string :unit

      t.timestamps
    end
  end
end
