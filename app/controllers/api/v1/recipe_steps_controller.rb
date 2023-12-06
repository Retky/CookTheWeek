class Api::V1::RecipeSteps < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_devise_api_token!

  def destroy
    @user = current_devise_api_token.resource_owner
    @recipe_step = RecipeStep.find(params[:id])
    if @recipe_step.recipe.user != @user
      render json: { errors: 'You are not allowed to delete this recipe step' }, status: :unprocessable_entity
    else
      @recipe_step.destroy
      render json: { message: 'Recipe step deleted' }
    end
end
