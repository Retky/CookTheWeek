class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_steps, dependent: :destroy

  validates :name, presence: true
  validates :portions, presence: true, default: 1, numericality: { greater_than: 0 }
  validates :preparation_time, presence: true, default: 0, numericality: { greater_than_or_equal_to: 0 }
  validates :cooking_time, presence: true, default: 0, numericality: { greater_than_or_equal_to: 0 }
  validates :public, inclusion: { in: [true, false] }, default: false
end
