require 'rails_helper'

RSpec.describe 'Api::V1::Ingredients', type: :request do
  before do
    Ingredient.create(name: 'Milk')
    Ingredient.create(name: 'Eggs')
    Ingredient.create(name: 'Flour')

    get '/api/v1/ingredients'
  end

  describe 'GET /index' do
    it 'should returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'should returns a proper JSON' do
      expect(response.content_type).to include('application/json')
    end

    it 'should returns all the ingredients' do
      parsed_body = response.parsed_body['ingredients']

      expect(parsed_body.length).to eq(3)
      expect(parsed_body[0]['name']).to eq('Milk')
      expect(parsed_body[1]['name']).to eq('Eggs')
      expect(parsed_body[2]['name']).to eq('Flour')
    end
  end
end
