require 'rails_helper'

describe 'Help', type: :model do
  before(:each) do
    @help = FactoryBot.create(:help)
  end
  context 'Validations' do
    it 'ensures that title is present' do
      @help.title = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that length of title is greater than 6' do
      @help.title = 'help '
      expect(@help).to_not be_valid
    end

    it 'ensures that title is present' do
      @help.description = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that length of title is greater than 20' do
      @help.description = 'My description'
      expect(@help).to_not be_valid
    end

    it 'ensures that longitude is present' do
      @help.long = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that longitude is a float' do
      @help.long = 'a32'
      expect(@help).to_not be_valid
    end

    it 'ensures that latitude is present' do
      @help.lat = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that latitude is a float' do
      @help.lat = '3a2'
      expect(@help).to_not be_valid
    end

    it 'ensures that category_id is present' do
      @help.category_id = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that category_id is a number' do
      @help.category_id = 'a'
      expect(@help).to_not be_valid
    end

    it 'ensures that category_id is a positive number' do
      @help.category_id = -1
      expect(@help).to_not be_valid
    end

    it 'ensures that user_id is present' do
      @help.user_id = nil
      expect(@help).to_not be_valid
    end

    it 'ensures that user_id is a number' do
      @help.user_id = 'a'
      expect(@help).to_not be_valid
      end

    it 'ensures that user_id is a positive number' do
      @help.user_id = -1
      expect(@help).to_not be_valid
    end
  end
end