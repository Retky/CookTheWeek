require 'rails_helper'

RSpec.describe 'Api::V1::Recipes', type: :request do
  before do
    # User registration
    post '/users/tokens/sign_up',
         params: { email: 'test@test.com', password: 'password', password_confirmation: 'password' }
    @user_id = response.parsed_body['resource_owner']['id']
    @token = response.parsed_body['token']

    @recipe = {
      recipe: {
        name: 'Recipe',
        description: '',
        portions: 3,
        difficulty: 2,
        preparation_time: 0.75,
        cooking_time: 1,
        public: false,
        tips: '',
        image_url: '',
        recipe_steps_attributes: [
          { id: nil, step_number: 1, instructions: 'Check Steps' },
          { id: nil, step_number: 2, instructions: 'Done' }
        ],
        recipe_ingredients_attributes: [
          { id: nil, name: 'Milk', quantity: 1.8, unit: 'liters' },
          { id: nil, name: 'Egg', quantity: 3, unit: 'piece' },
          { id: nil, name: 'Flour', quantity: 200, unit: 'grams' }
        ]
      }
    }
  end

  describe 'GET /index' do
    it 'should returns http unauthorized when no token is provided' do
      get '/api/v1/users/1/recipes'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      get "/api/v1/users/#{@user_id}/recipes", headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns a list of recipes' do
      get "/api/v1/users/#{@user_id}/recipes", headers: { 'Authorization' => @token }
      expect(response.parsed_body).to eq([])
    end
  end

  describe 'POST /create' do
    it 'should returns http unauthorized when no token is provided' do
      post '/api/v1/users/1/recipes', params: @recipe
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns the same recipe' do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      expect(response.parsed_body['name']).to eq(@recipe[:recipe][:name])
    end
    it 'should returns a recipe with ingredients' do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      recipe_ingredients = response.parsed_body['recipe_ingredients']
      expect(recipe_ingredients.count).to eq(@recipe[:recipe][:recipe_ingredients_attributes].count)
      expect(recipe_ingredients.count).to eq(3)
    end
    it 'should returns a recipe with steps' do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      recipe_steps = response.parsed_body['recipe_steps']
      expect(recipe_steps.count).to eq(@recipe[:recipe][:recipe_steps_attributes].count)
      expect(recipe_steps.count).to eq(2)
    end
  end

  describe 'GET /show' do
    before do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      @recipe_id = response.parsed_body['id']
    end

    it 'should returns http unauthorized when no token is provided' do
      get "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}"
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      get "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns a recipe' do
      get "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      expect(response.parsed_body['name']).to eq(@recipe[:recipe][:name])
      expect(response.parsed_body['id']).to eq(@recipe_id)
      expect(response.parsed_body['user_id']).to eq(@user_id)
    end
    it 'should returns a recipe with ingredients' do
      get "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      recipe_ingredients = response.parsed_body['recipe_ingredients']
      expect(recipe_ingredients.count).to eq(@recipe[:recipe][:recipe_ingredients_attributes].count)
      expect(recipe_ingredients.count).to eq(3)
    end
    it 'should returns a recipe with steps' do
      get "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      recipe_steps = response.parsed_body['recipe_steps']
      expect(recipe_steps.count).to eq(@recipe[:recipe][:recipe_steps_attributes].count)
      expect(recipe_steps.count).to eq(2)
    end
  end

  describe 'PUT /update' do
    before do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      @recipe_id = response.parsed_body['id']

      @recipe[:recipe][:name] = 'New Recipe'
    end

    it 'should returns http unauthorized when no token is provided' do
      put "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", params: @recipe
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      @recipe_id = response.parsed_body['id']
      put "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", params: @recipe, headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns the updated recipe' do
      put "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", params: @recipe, headers: { 'Authorization' => @token }
      expect(response.parsed_body['name']).to eq('New Recipe')
    end
  end

  describe 'DELETE /destroy' do
    before(:each) do
      post "/api/v1/users/#{@user_id}/recipes", params: @recipe, headers: { 'Authorization' => @token }
      @recipe_id = response.parsed_body['id']
    end

    it 'should returns http unauthorized when no token is provided' do
      delete "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}"
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should returns http success' do
      delete "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      expect(response).to have_http_status(:success)
    end
    it 'should returns a message' do
      delete "/api/v1/users/#{@user_id}/recipes/#{@recipe_id}", headers: { 'Authorization' => @token }
      expect(response.parsed_body['message']).to eq('Recipe deleted')
    end
  end
end
