class ShopList < ApplicationRecord
  belongs_to :user
  has_many :shop_list_ingredients, dependent: :destroy
  has_many :ingredients, through: :shop_list_ingredients
  has_many :shop_list_meals, dependent: :destroy
  has_many :meals, through: :shop_list_meals

  def return_data
    recipe_ingredients = meals.map(&:recipe_id).map { |id| RecipeIngredient.where(recipe_id: id) }.flatten

    grouped_ingredients = recipe_ingredients.group_by { |ingredient| [ingredient.ingredient_id, ingredient.unit] }

    summed_ingredients = grouped_ingredients.map do |(ingredient_id, unit), ingredients|
      {
        name: ingredients.first.ingredient.name,
        ingredient_id:,
        unit:,
        quantity: ingredients.sum(&:quantity)
      }
    end

    {
      id: self.id,
      ingredients: summed_ingredients,
      meals:
    }
  end
end
