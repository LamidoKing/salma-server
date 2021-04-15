require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user_data = {
      first_name: 'salma',
      last_name: 'mohamed',
      email: 'hj@email.com',
      password: 'pass123',
      government_id: 'kdkdkdkkddkkddkkd'
    }
    @user = FactoryBot.create(:user, @user_data)
  end
  context 'validations' do
    it('ensures the presence of first name') do
      @user.first_name = nil
      expect(@user).to_not be_valid
    end

    it('ensures that the length of first name is more than 1') do
      @user.first_name = 'a'
      expect(@user).to_not be_valid
    end

    it('ensures the presence of last name') do
      @user.last_name = nil
      expect(@user).to_not be_valid
    end

    it('ensures that the length of last name is more than 1') do
      @user.last_name = 'a'
      expect(@user).to_not be_valid
    end

    it('ensures the presence of email address') do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it('ensures that email is valid') do
      @user.email = 'abc'
      expect(@user).to_not be_valid
    end

    it('ensures that email is unique') do
      user2 = FactoryBot.build(:user, @user_data)
      expect {user2.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it('ensures the presence of password') do
      @user.password = nil
      expect(@user).to_not be_valid
    end

    it('ensures the length of password is not less than 6') do
      @user.password = 'passw'
      expect(@user).to_not be_valid
    end

    it('ensures the presence of government issued ID') do
      @user.government_id = nil
      expect(@user).to_not be_valid
    end

  end
end
