class ShopListMeal < ApplicationRecord
  belongs_to :shop_list
  belongs_to :meal
end
