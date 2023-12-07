require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(email: 'test@test.com', password: 'password')
  end

  describe 'Creation' do
    it 'should create a user' do
      expect(@user).to be_valid
      @user.save
      expect(User.count).to eq(1)
      expect(User.first).to eq(@user)
    end
    it 'should NOT create a user without an email' do
      @user.email = ''
      expect(@user).to_not be_valid
    end
    it 'should NOT create a user without a password' do
      @user.password = ''
      expect(@user).to_not be_valid
    end
    it 'should NOT save an invalid user' do
      @user.email = ''
      expect(@user).to_not be_valid
      @user.save
      expect(User.count).to eq(0)
    end
  end

  describe 'Validations' do
    it 'should have a unique email' do
      @user.save
      @user2 = @user.dup
      expect(@user2).to_not be_valid
    end
    it 'should NOT invalidate a user with a duplicated password' do
      @user.save
      @user2 = @user.dup
      @user2.email = 'test2@test.com'
      expect(@user2).to be_valid
    end
    it 'should have a valid email' do
      @user.email = 'testemailcom'
      expect(@user).to_not be_valid
      @user.email = 'testemail.com'
      expect(@user).to_not be_valid
      @user.email = 'test@test.com'
      expect(@user).to be_valid
    end
  end
  describe 'Update' do
    it 'should update a user' do
      @user.save
      @user.update(email: 'test2@test.com')
      expect(User.first.email).to eq('test2@test.com')
    end
    it 'should NOT update a user with an invalid email' do
      @user.save
      @user.update(email: '')
      expect(User.first.email).to eq('test@test.com')
    end
    it 'should NOT update a user with a duplicated email' do
      @user.save
      @user2 = @user.dup
      @user2.email = 'test2@test.com'
      @user2.save
      @user.update(email: 'test2@test.com')
      expect(User.first.email).to eq('test@test.com')
    end
  end
  describe 'Delete' do
    it 'should delete a user' do
      @user.save
      expect(User.count).to eq(1)
      User.first.delete
      expect(User.count).to eq(0)
    end
  end
end
