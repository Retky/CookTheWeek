class Api::V1::IngredientsController < ApplicationController
  # All ingredients
  def index
    @ingredients = Ingredient.all
    render json: { ingredients: @ingredients }
  end
end
