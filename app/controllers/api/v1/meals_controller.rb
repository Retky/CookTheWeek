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

  def update
    @meal = Meal.find(params[:id])

    if @meal.update(meal_params)
      render json: @meal
    else
      render json: { errors: @meal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @meal = Meal.find(params[:id])
    @meal.destroy
    render json: { message: 'Meal deleted' }
  end

  private

  def meal_params
    params.require(:meal).permit(
      :name, :day, :portions, :recipe_id
    )
  end
end
