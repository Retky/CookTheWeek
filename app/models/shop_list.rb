class ShopList < ApplicationRecord
  belongs_to :user
  has_many :shop_list_ingredients, dependent: :destroy
  has_many :ingredients, through: :shop_list_ingredients
  has_many :shop_list_meals, dependent: :destroy
  has_many :meals, through: :shop_list_meals
end
