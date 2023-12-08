require 'rails_helper'

RSpec.describe RecipeStep, type: :model do
  before(:each) do
    @user = User.create(email: 'test@test.com', password: 'password')
    @recipe = Recipe.create(user: @user, name: 'test recipe', description: 'test description', portions: 1,
                            preparation_time: 0.5, cooking_time: 0.15, public: true)
    @recipe_step = RecipeStep.new(recipe: @recipe, step_number: 1, instructions: 'test instructions')
  end

  describe 'Creation' do
    it 'should create a recipe step' do
      expect(@recipe_step).to be_valid
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first).to eq(@recipe_step)
    end
    it 'should NOT create a recipe step without a recipe' do
      @recipe_step.recipe = nil
      expect(@recipe_step).to_not be_valid
    end
    it 'should NOT create a recipe step without a step_number' do
      @recipe_step.step_number = nil
      expect(@recipe_step).to_not be_valid
    end
    it 'should NOT create a recipe step without instructions' do
      @recipe_step.instructions = ''
      expect(@recipe_step).to_not be_valid
    end
  end

  describe 'Validations' do
    it 'should NOT invalidate a recipe step with a duplicated step_number' do
      @recipe_step.save
      @recipe_step2 = @recipe_step.dup
      expect(@recipe_step2).to be_valid
    end
    it 'should NOT invalidate a recipe step with a duplicated instructions' do
      @recipe_step.save
      @recipe_step2 = @recipe_step.dup
      @recipe_step2.step_number = 2
      expect(@recipe_step2).to be_valid
    end
    it 'should NOT create a recipe step with wrong step_number' do
      @recipe_step.step_number = ''
      expect(@recipe_step).to_not be_valid
      @recipe_step.step_number = -1
      expect(@recipe_step).to_not be_valid
    end
    it 'should create a recipe step with decimal step_number' do
      @recipe_step.step_number = 1.1
      expect(@recipe_step).to be_valid
    end
    it 'should create a recipe step with zero step_number' do
      @recipe_step.step_number = 0
      expect(@recipe_step).to be_valid
    end
  end

  describe 'Update' do
    it 'should update a recipe step' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe_step.update(step_number: 2)
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first.step_number).to eq(2)
    end
    it 'should NOT update a recipe step without a recipe' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe_step.update(recipe: nil)
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first.recipe).to eq(@recipe)
    end
    it 'should NOT update a recipe step without a step_number' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe_step.update(step_number: nil)
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first.step_number).to eq(1)
    end
    it 'should NOT update a recipe step without instructions' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe_step.update(instructions: '')
      expect(RecipeStep.count).to eq(1)
      expect(RecipeStep.first.instructions).to eq('test instructions')
    end
  end

  describe 'Destroy' do
    it 'should destroy a recipe step' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe_step.destroy
      expect(RecipeStep.count).to eq(0)
    end
    it 'should be destroyed when recipe is destroyed' do
      @recipe_step.save
      expect(RecipeStep.count).to eq(1)
      @recipe.destroy
      expect(RecipeStep.count).to eq(0)
    end
  end

  describe 'Associations' do
    it 'should belong to a recipe' do
      expect(@recipe_step.recipe).to eq(@recipe)
    end
  end
end
