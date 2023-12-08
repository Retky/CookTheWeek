require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  before(:each) do
    @user = User.create(email: 'test@test.com', password: 'password')
    @recipe = Recipe.create(user: @user, name: 'test recipe', description: 'test description', portions: 1,
                            preparation_time: 0.5, cooking_time: 0.15, public: true)
    @ingredient = Ingredient.create(name: 'test ingredient')
    @recipe_ingredient = RecipeIngredient.new(recipe: @recipe, ingredient: @ingredient, quantity: 1, unit: 'kg')
  end

  describe 'Creation' do
    it 'should create a recipe_ingredient' do
      expect(@recipe_ingredient).to be_valid
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
    end
    it 'should NOT create a recipe_ingredient without a recipe' do
      @recipe_ingredient.recipe = nil
      expect(@recipe_ingredient).to_not be_valid
    end
    it 'should NOT create a recipe_ingredient without an ingredient' do
      @recipe_ingredient.ingredient = nil
      expect(@recipe_ingredient).to_not be_valid
    end
    it 'should NOT create a recipe_ingredient without a quantity' do
      @recipe_ingredient.quantity = nil
      expect(@recipe_ingredient).to_not be_valid
    end
    it 'should NOT create a recipe_ingredient without a unit' do
      @recipe_ingredient.unit = nil
      expect(@recipe_ingredient).to_not be_valid
    end
    it 'should NOT save an invalid recipe_ingredient' do
      @recipe_ingredient.recipe = nil
      expect(@recipe_ingredient).to_not be_valid
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(0)
    end
  end

  describe 'Validations' do
    it 'should NOT invalidate a recipe_ingredient with a duplicated recipe and ingredient' do
      @recipe_ingredient.save
      @recipe_ingredient2 = @recipe_ingredient.dup
      expect(@recipe_ingredient2).to be_valid
    end
    it 'should NOT create a recipe_ingredient with wrong quantity' do
      @recipe_ingredient.quantity = ''
      expect(@recipe_ingredient).to_not be_valid
      @recipe_ingredient.quantity = -1
      expect(@recipe_ingredient).to_not be_valid
    end
    it 'should NOT create a recipe_ingredient with wrong unit' do
      @recipe_ingredient.unit = ''
      expect(@recipe_ingredient).to_not be_valid
    end
  end

  describe 'Update' do
    it 'should update a recipe_ingredient' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(quantity: 2)
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first.quantity).to eq(2)
    end
    it 'should NOT update a recipe_ingredient without a recipe' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(recipe: nil)
      expect(RecipeIngredient.first.recipe).to eq(@recipe)
    end
    it 'should NOT update a recipe_ingredient without an ingredient' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(ingredient: nil)
      expect(RecipeIngredient.first.ingredient).to eq(@ingredient)
    end
    it 'should NOT update a recipe_ingredient without a quantity' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(quantity: nil)
      expect(RecipeIngredient.first.quantity).to eq(1)
    end
    it 'should NOT update a recipe_ingredient without a unit' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(unit: nil)
      expect(RecipeIngredient.first.unit).to eq('kg')
    end
    it 'should NOT update a recipe_ingredient with wrong quantity' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(quantity: '')
      expect(RecipeIngredient.first.quantity).to eq(1)
      @recipe_ingredient.update(quantity: -1)
      expect(RecipeIngredient.first.quantity).to eq(1)
    end
    it 'should NOT update a recipe_ingredient with wrong unit' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.update(unit: '')
      expect(RecipeIngredient.first.unit).to eq('kg')
    end
  end

  describe 'Destroy' do
    it 'should destroy a recipe_ingredient' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe_ingredient.destroy
      expect(RecipeIngredient.count).to eq(0)
    end
    it 'should be destroyed when recipe is destroyed' do
      @recipe_ingredient.save
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first).to eq(@recipe_ingredient)
      @recipe.destroy
      expect(RecipeIngredient.count).to eq(0)
    end
  end

  describe 'Associations' do
    it 'should belong to a recipe' do
      expect(@recipe_ingredient.recipe).to eq(@recipe)
    end
    it 'should belong to an ingredient' do
      expect(@recipe_ingredient.ingredient).to eq(@ingredient)
    end
  end
end
