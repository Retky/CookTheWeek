class Api::V1::RecipesController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_devise_api_token!

  def index
    @user = current_devise_api_token.resource_owner
    @recipes = @user.recipes
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: @recipe.full_recipe
  end

  def create
    @user = current_devise_api_token.resource_owner
    @recipe = @user.recipes.build(recipe_params)

    Recipe.transaction do
      if @recipe.save
        @recipe.define_ingredients(params[:recipe][:recipe_ingredients_attributes])
        @recipe.define_steps(params[:recipe][:recipe_steps_attributes])
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
        update_or_create_recipe_steps(params[:recipe][:recipe_steps_attributes], @recipe)
        update_or_create_recipe_ingredients(params[:recipe][:recipe_ingredients_attributes], @recipe)
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
      :name, :portions, :preparation_time, :cooking_time, :public
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

  def update_or_create_recipe_ingredients(ingredients, recipe)
    return if ingredients.blank?

    ingredients.each do |ingredient_params|
      recipe_ingredient = RecipeIngredient.find_by(id: ingredient_params[:id]) if ingredient_params[:id].present?

      ingredient = Ingredient.find_or_create_by(name: ingredient_params[:name])
      next unless ingredient

      if recipe_ingredient.present? && recipe_ingredient.ingredient.name == ingredient_params[:name]
        recipe_ingredient.update(
          quantity: ingredient_params[:quantity],
          unit: ingredient_params[:unit]
        )
      else
        recipe.recipe_ingredients.create(
          ingredient:,
          quantity: ingredient_params[:quantity],
          unit: ingredient_params[:unit]
        )
      end
    end
  end

  def update_or_create_recipe_steps(steps, recipe)
    return if steps.blank?

    steps.each do |step_params|
      recipe_step = (RecipeStep.find_by(id: step_params[:id]) if step_params[:id].present?)

      if recipe_step.present?
        recipe_step.update(
          step_number: step_params[:step_number],
          instructions: step_params[:instructions]
        )
      else
        recipe.recipe_steps.create(
          step_number: step_params[:step_number],
          instructions: step_params[:instructions]
        )
      end
    end
  end
end
