class Api::V1::RecipeIngredientsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_devise_api_token!

  def destroy
    @user = current_devise_api_token.resource_owner
    @recipe_ingredient = RecipeIngredient.find(params[:id])
    if @recipe_ingredient.recipe.user != @user
      render json: { errors: 'You are not allowed to delete this recipe ingredient' }, status: :unprocessable_entity
    else
      @recipe_ingredient.destroy
      render json: { message: 'Recipe ingredient deleted' }
    end
  end
end
