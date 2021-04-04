require 'rails_helper'

RSpec.describe Chat, type: :model do
  before :each do
    @chat = FactoryBot.create :chat
  end

  it 'should validate the presence of message' do
    @chat.message = '';
    expect(@chat).to_not be_valid  
  end
end
