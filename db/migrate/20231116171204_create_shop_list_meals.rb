class CreateShopListMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_list_meals do |t|
      t.references :shop_list, null: false, foreign_key: true
      t.references :meal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
