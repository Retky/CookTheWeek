class Api::V1::RecipesController < ApplicationController
  # before_action authenticate_user!

  def index
    @recipes = current_user.recipes
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: @recipe.full_recipe
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
  
    Recipe.transaction do
      if @recipe.save
        @recipe.define_ingredients(params[:recipe][:recipe_ingredients_attributes])
        render json: @recipe
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    render json: { message: 'Recipe deleted' }
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :name, :portions, :preparation_time, :cooking_time, :public,
      recipe_steps_attributes: [:step_number, :instructions]
    )
  end

  def build_recipe_ingredients(ingredients, recipe)
    return unless ingredients.present?
  
    ingredients.each do |ingredient_params|
      ingredient = Ingredient.find_or_create_by(name: ingredient_params[:name])
      next unless ingredient
  
      recipe.recipe_ingredients.create(
        ingredient: ingredient,
        quantity: ingredient_params[:quantity],
        unit: ingredient_params[:unit]
      )
    end
  end
end
