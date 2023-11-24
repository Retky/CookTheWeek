class Api::V1::RecipesController < ApplicationController
  # before_action authenticate_user!

  def index
    # @recipes = current_user.recipes
    # render json: @recipes
    render json: "This is the index action with user_id: #{params[:user_id]}"
  end

  def show
    # @recipe = Recipe.find(params[:id])
    # render json: @recipe
    render json: "This is the show action with id: #{params[:id]}"
  end

  def create
    # @recipe = Recipe.new(recipe_params)
    # @recipe.user = current_user
    # @recipe.save
    # render json: @recipe
    render json: "This is the create action with user_id: #{params[:user_id]}"
  end
end
