class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_steps, dependent: :destroy

  validates :name, presence: true
  validates :portions, numericality: { greater_than: 0 }
  validates :preparation_time, numericality: { greater_than_or_equal_to: 0 }
  validates :cooking_time, numericality: { greater_than_or_equal_to: 0 }
  validates :public, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :recipe_ingredients, :recipe_steps

  def define_steps(steps)
    recipe_steps.create(steps)
  end

  def define_ingredients(ingredients)
    ingredients.each do |ingredient_params|
      ingredient = Ingredient.find_or_create_by(name: ingredient_params[:name])
      recipe_ingredients.create(ingredient_id: ingredient.id, quantity: ingredient_params[:quantity],
                                unit: ingredient_params[:unit])
    end
  end
end
