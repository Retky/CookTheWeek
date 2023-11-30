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

  def update
    @recipe = Recipe.find(params[:id])

    Recipe.transaction do
      if @recipe.update(recipe_params)
        update_recipe_ingredients(params[:recipe][:recipe_ingredients_attributes], @recipe)
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
      recipe_steps_attributes: %i[step_number instructions]
    )
  end

  def build_recipe_ingredients(ingredients, recipe)
    return if ingredients.blank?

    ingredients.each do |ingredient_params|
      ingredient = Ingredient.find_or_create_by(name: ingredient_params[:name])
      next unless ingredient

      recipe.recipe_ingredients.create(
        ingredient:,
        quantity: ingredient_params[:quantity],
        unit: ingredient_params[:unit]
      )
    end
  end

  def update_recipe_ingredients(ingredients, recipe)
    return if ingredients.blank?

    ingredients.each do |ingredient_params|
      recipe_ingredient = RecipeIngredient.find_or_initialize_by(id: ingredient_params[:id])

      if ingredient_params[:_destroy] == '1' # Check if marked for deletion
        recipe_ingredient.destroy if recipe_ingredient.persisted?
        next
      end

      ingredient = Ingredient.find_or_create_by(name: ingredient_params[:name])
      next unless ingredient

      # Update the recipe ingredient attributes
      recipe_ingredient.update(
        ingredient: ingredient,
        quantity: ingredient_params[:quantity],
        unit: ingredient_params[:unit]
      )
    end
  end
end
