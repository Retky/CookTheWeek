require 'rails_helper'

RSpec.describe Recipe, type: :model do
  before(:each) do
    @user = User.create(email: 'test@test.com', password: 'password')
    @recipe = Recipe.new(user: @user, name: 'test recipe', description: 'test description', portions: 1,
                         preparation_time: 0.5, cooking_time: 0.15, public: true)
  end

  describe 'Creation' do
    it 'should create a recipe' do
      expect(@recipe).to be_valid
      @recipe.save
      expect(Recipe.count).to eq(1)
      expect(Recipe.first).to eq(@recipe)
    end
    it 'should NOT create a recipe without a user' do
      @recipe.user = nil
      expect(@recipe).to_not be_valid
    end
    it 'should NOT create a recipe without a name' do
      @recipe.name = ''
      expect(@recipe).to_not be_valid
    end
    it 'should NOT save an invalid recipe' do
      @recipe.name = ''
      expect(@recipe).to_not be_valid
      @recipe.save
      expect(Recipe.count).to eq(0)
    end
  end

  describe 'Validations' do
    it 'should NOT invalidate a recipe with a duplicated name' do
      @recipe.save
      @recipe2 = @recipe.dup
      expect(@recipe2).to be_valid
    end
    it 'should NOT create a recipe with wrong portions' do
      @recipe.portions = ''
      expect(@recipe).to_not be_valid
      @recipe.portions = -1
      expect(@recipe).to_not be_valid
      @recipe.portions = 0
      expect(@recipe).to_not be_valid
    end
    it 'should NOT create a recipe with wrong preparation_time' do
      @recipe.preparation_time = ''
      expect(@recipe).to_not be_valid
      @recipe.preparation_time = -1
      expect(@recipe).to_not be_valid
    end
    it 'should NOT create a recipe with wrong cooking_time' do
      @recipe.cooking_time = ''
      expect(@recipe).to_not be_valid
      @recipe.cooking_time = -1
      expect(@recipe).to_not be_valid
    end
    it 'should NOT create a recipe with wrong public' do
      @recipe.public = ''
      expect(@recipe).to_not be_valid
    end
    it 'should create a recipe with no description' do
      @recipe.description = ''
      expect(@recipe).to be_valid
    end
    it 'should create a recipe with public true or false' do
      @recipe.public = true
      expect(@recipe).to be_valid
      @recipe.public = false
      expect(@recipe).to be_valid
    end
  end

  describe 'Update' do
    it 'should update a recipe' do
      @recipe.save
      @recipe.update(name: 'test recipe2')
      expect(Recipe.first.name).to eq('test recipe2')
    end
    it 'should NOT update a recipe with an invalid name' do
      @recipe.save
      @recipe.update(name: '')
      expect(Recipe.first.name).to eq('test recipe')
    end
    it 'should update a recipe with no description' do
      @recipe.save
      @recipe.update(description: '')
      expect(Recipe.first.description).to eq('')
    end
    it 'should update a recipe with public true or false' do
      @recipe.save
      @recipe.update(public: true)
      expect(Recipe.first.public).to eq(true)
      @recipe.update(public: false)
      expect(Recipe.first.public).to eq(false)
    end
    it 'should NOT update a recipe with wrong portions' do
      @recipe.save
      @recipe.update(portions: '')
      expect(Recipe.first.portions).to eq(1)
      @recipe.update(portions: -1)
      expect(Recipe.first.portions).to eq(1)
      @recipe.update(portions: 0)
      expect(Recipe.first.portions).to eq(1)
    end
    it 'should NOT update a recipe with wrong preparation_time' do
      @recipe.save
      @recipe.update(preparation_time: '')
      expect(Recipe.first.preparation_time).to eq(0.5)
      @recipe.update(preparation_time: -1)
      expect(Recipe.first.preparation_time).to eq(0.5)
    end
    it 'should NOT update a recipe with wrong cooking_time' do
      @recipe.save
      @recipe.update(cooking_time: '')
      expect(Recipe.first.cooking_time).to eq(0.15)
      @recipe.update(cooking_time: -1)
      expect(Recipe.first.cooking_time).to eq(0.15)
    end
    it 'should NOT update a recipe with wrong public' do
      @recipe.save
      @recipe.update(public: '')
      expect(Recipe.first.public).to eq(true)
    end
    it 'should update a recipe with valid portions' do
      @recipe.save
      @recipe.update(portions: 2)
      expect(Recipe.first.portions).to eq(2)
    end
    it 'should update a recipe with valid preparation_time' do
      @recipe.save
      @recipe.update(preparation_time: 1)
      expect(Recipe.first.preparation_time).to eq(1)
      @recipe.update(preparation_time: 0)
      expect(Recipe.first.preparation_time).to eq(0)
    end
    it 'should update a recipe with valid cooking_time' do
      @recipe.save
      @recipe.update(cooking_time: 1)
      expect(Recipe.first.cooking_time).to eq(1)
      @recipe.update(cooking_time: 0)
      expect(Recipe.first.cooking_time).to eq(0)
    end
  end

  describe 'Destroy' do
    it 'should destroy a recipe' do
      @recipe.save
      expect(Recipe.count).to eq(1)
      Recipe.first.destroy
      expect(Recipe.count).to eq(0)
    end
    it 'should be destroyed when the user is destroyed' do
      @recipe.save
      expect(Recipe.count).to eq(1)
      @user.destroy
      expect(User.count).to eq(0)
      expect(Recipe.count).to eq(0)
    end
  end

  describe 'Associations' do
    it 'should belong to a user' do
      expect(@recipe.user).to eq(@user)
    end
    it 'should have many recipe_ingredients' do
      expect(@recipe.recipe_ingredients).to eq([])
    end
    it 'should have many ingredients through recipe_ingredients' do
      expect(@recipe.ingredients).to eq([])
    end
    it 'should have many recipe_steps' do
      expect(@recipe.recipe_steps).to eq([])
    end
    it 'should belong to a user' do
      expect(@recipe.user).to eq(@user)
    end
  end
end
