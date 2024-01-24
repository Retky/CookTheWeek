class Api::V1::MealsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_devise_api_token!

  def index
    @meals = Meal.all
    render json: @meals
  end

  def create
    @user = current_devise_api_token.resource_owner
    @meal = @user.meals.build(meal_params)

    if @meal.save
      render json: @meal
    else
      render json: { errors: @meal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def meal_params
    params.require(:meal).permit(
      :name, :day, :portions, :recipe_id
      )
  end
end
