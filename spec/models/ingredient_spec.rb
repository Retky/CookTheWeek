require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  before(:each) do
    @ingredient = Ingredient.new(name: 'test ingredient')
  end

  describe 'Creation' do
    it 'should create an ingredient' do
      expect(@ingredient).to be_valid
      @ingredient.save
      expect(Ingredient.count).to eq(1)
      expect(Ingredient.first).to eq(@ingredient)
    end
    it 'should NOT create an ingredient without a name' do
      @ingredient.name = ''
      expect(@ingredient).to_not be_valid
    end
    it 'should NOT save an invalid ingredient' do
      @ingredient.name = ''
      expect(@ingredient).to_not be_valid
      @ingredient.save
      expect(Ingredient.count).to eq(0)
    end
  end

  describe 'Validations' do
    it 'should NOT save an ingredient with a duplicated name' do
      @ingredient.save
      @ingredient2 = @ingredient.dup
      expect(@ingredient2).to_not be_valid
    end
    it 'should NOT be case sensitive' do
      @ingredient.save
      @ingredient2 = Ingredient.new(name: 'TEST INGREDIENT')
      expect(@ingredient2).to_not be_valid
    end
  end

  describe 'Sanitizer' do
    it 'should Capitalize the first letter' do
      @ingredient.save
      expect(@ingredient.name).to eq('Test ingredient')
    end
    it 'should lowercase the rest of the letters' do
      @ingredient.name = 'TEST INGREDIENT'
      @ingredient.save
      expect(@ingredient.name).to eq('Test ingredient')
    end
    it 'should remove any punctuation' do
      @ingredient.name = 'test ingredient!'
      @ingredient.save
      expect(@ingredient.name).to eq('Test ingredient')
    end
    it 'should NOT remove any numbers' do
      @ingredient.name = 'torres 40'
      @ingredient.save
      expect(@ingredient.name).to eq('Torres 40')
    end
    it 'should NOT remove any spaces' do
      @ingredient.save
      expect(@ingredient.name).to eq('Test ingredient')
    end
  end

  describe 'Update' do
    it 'should update an ingredient' do
      @ingredient.save
      @ingredient.update(name: 'test ingredient2')
      expect(Ingredient.first.name).to eq('Test ingredient2')
    end
    it 'should NOT update an ingredient with an invalid name' do
      @ingredient.save
      @ingredient.update(name: '')
      expect(Ingredient.first.name).to eq('Test ingredient')
    end
    it 'should NOT update an ingredient with a duplicated name' do
      @ingredient.save
      @ingredient2 = Ingredient.new(name: 'test ingredient2')
      @ingredient2.save
      @ingredient.update(name: 'test ingredient2')
      expect(Ingredient.first.name).to eq('Test ingredient')
    end
  end

  describe 'Destroy' do
    it 'should destroy an ingredient' do
      @ingredient.save
      @ingredient.destroy
      expect(Ingredient.count).to eq(0)
    end
  end

  describe 'Associations' do
    it 'should have many recipe_ingredients' do
      expect(@ingredient.recipe_ingredients).to eq([])
    end
    it 'should have many recipes through recipe_ingredients' do
      expect(@ingredient.recipes).to eq([])
    end
    it 'should have many shop_list_ingredients' do
      expect(@ingredient.shop_list_ingredients).to eq([])
    end
    it 'should have many shop_lists through shop_list_ingredients' do
      expect(@ingredient.shop_lists).to eq([])
    end
  end
end
