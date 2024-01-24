class Meal < ApplicationRecord
  belongs_to :user
  has_many :shop_list_meals, dependent: :destroy
  has_many :shop_lists, through: :shop_lists_meals

  validates :recipe_id, presence: true
  validates :day, presence: true
end
