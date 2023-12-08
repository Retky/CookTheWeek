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
  end

  # Custom Methods
  describe 'Full Recipe Method' do
    before do
      @recipe.save
      @ingredient = Ingredient.create(name: 'test ingredient')
      @recipe.recipe_ingredients.create(ingredient: @ingredient, quantity: 1, unit: 'test unit')
      @recipe.recipe_steps.create(step_number: 1, instructions: 'test instructions')
      @full_recipe = @recipe.full_recipe
    end
    it 'should have the correct Recipe attributes' do
      expect(@full_recipe['id']).to eq(@recipe.id)
      expect(@full_recipe['user_id']).to eq(@recipe.user_id)
      expect(@full_recipe['name']).to eq(@recipe.name)
      expect(@full_recipe['difficulty']).to eq(@recipe.difficulty)
      expect(@full_recipe['description']).to eq(@recipe.description)
      expect(@full_recipe['portions']).to eq(@recipe.portions)
      expect(@full_recipe['preparation_time']).to eq(@recipe.preparation_time)
      expect(@full_recipe['cooking_time']).to eq(@recipe.cooking_time)
      expect(@full_recipe['public']).to eq(@recipe.public)
      expect(@full_recipe['image_url']).to eq(@recipe.image_url)
      expect(@full_recipe['tips']).to eq(@recipe.tips)
      expect(@full_recipe).to have_key('created_at')
      expect(@full_recipe).to have_key('updated_at')
    end
    it 'should have the correct Recipe Ingredient attributes' do
      expect(@full_recipe['recipe_ingredients'].count).to eq(1)
      @recipe_ingredient = @full_recipe['recipe_ingredients'].first

      expect(@recipe_ingredient['quantity']).to eq(@recipe.recipe_ingredients.first.quantity)
      expect(@recipe_ingredient['unit']).to eq(@recipe.recipe_ingredients.first.unit)
      expect(@recipe_ingredient['name']).to eq(@recipe.recipe_ingredients.first.ingredient.name)
      expect(@recipe_ingredient).to have_key('id')
      expect(@recipe_ingredient).to have_key('created_at')
      expect(@recipe_ingredient).to have_key('updated_at')
    end
    it 'should have the correct Recipe Step attributes' do
      expect(@full_recipe['steps'].count).to eq(1)
      @recipe_step = @full_recipe['steps'].first

      expect(@recipe_step['instructions']).to eq(@recipe.recipe_steps.first.instructions)
      expect(@recipe_step['step_number']).to eq(@recipe.recipe_steps.first.step_number)
      expect(@recipe_step['id']).to eq(@recipe.recipe_steps.first.id)
      expect(@recipe_step).to have_key('created_at')
      expect(@recipe_step).to have_key('updated_at')
    end
  end

  describe 'Define Ingredients Method' do
    before do
      @recipe.save
      @recipe.define_ingredients([{ name: 'test ingredient', quantity: 1, unit: 'test unit' }])
    end

    it 'should create the ingredient' do
      expect(Ingredient.count).to eq(1)
      expect(Ingredient.first.name).to eq('Test ingredient')
    end
    it 'should NOT create the ingredient if it already exists' do
      @recipe.define_ingredients([{ name: 'test ingredient', quantity: 1, unit: 'test unit' }])
      expect(Ingredient.count).to eq(1)
      expect(Ingredient.first.name).to eq('Test ingredient')
    end
    it 'should create the recipe_ingredient' do
      expect(RecipeIngredient.count).to eq(1)
      expect(RecipeIngredient.first.quantity).to eq(1)
      expect(RecipeIngredient.first.unit).to eq('test unit')
      expect(RecipeIngredient.first.ingredient).to eq(Ingredient.first)
      expect(RecipeIngredient.first.recipe).to eq(@recipe)

      expect(@recipe.ingredients.count).to eq(1)
      expect(@recipe.ingredients.first).to eq(Ingredient.first)
    end
  end

  describe 'Define Steps Method' do
    before do
      @recipe.save
      @recipe.define_steps([{ step_number: 1, instructions: 'test instructions' }])
    end

    it 'should create the recipe_step' do
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first.step_number).to eq(1)
      expect(RecipeStep.first.instructions).to eq('test instructions')
      expect(RecipeStep.first.recipe).to eq(@recipe)

      expect(@recipe.recipe_steps.count).to eq(1)
      expect(@recipe.recipe_steps.first).to eq(RecipeStep.first)
    end
  end
end
