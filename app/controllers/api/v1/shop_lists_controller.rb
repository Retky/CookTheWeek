class Api::V1::ShopListsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_devise_api_token!

  def index
    @user = current_devise_api_token.resource_owner
    @shop_lists = @user.shop_lists
    render json: @shop_lists
  end

  def show
    @shop_list = ShopList.find(params[:id])
    render json: @shop_list.all_ingredients
  end

  def create
    @user = current_devise_api_token.resource_owner
    @shop_list = @user.shop_lists.build(shop_list_params)
  
    ShopList.transaction do
      if @shop_list.save
        params[:shop_list][:meal_ids].each do |meal_id|
          meal = Meal.find_by(id: meal_id)
          @shop_list.meals << meal unless @shop_list.meals.include?(meal) if meal.present?
        end
        render json: @shop_list.all_ingredients
      else
        render json: { errors: @shop_list.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
  end

  def destroy
    @shop_list = ShopList.find(params[:id])
    @shop_list.destroy
    render json: { message: 'Shop list deleted' }
  end

  private

  def shop_list_params
    params.require(:shop_list).permit(
      :meal_ids => []
    )
  end
end
