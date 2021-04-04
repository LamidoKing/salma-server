require 'rails_helper'

describe 'Category', type: :model do
  context 'validations' do
    before :each do
      @category = FactoryBot.create :category
    end

    it 'ensures that name is present' do
      @category.name = nil
      expect(@category).to_not be_valid
    end

    it 'ensures that color is present' do
      @category.color = nil
      expect(@category).to_not be_valid
    end
  end
end