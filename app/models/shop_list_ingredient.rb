class ShopListIngredient < ApplicationRecord
  belongs_to :ingredient
  belongs_to :shop_list
end
