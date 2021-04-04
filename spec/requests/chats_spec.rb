include TokenHelper

describe 'Chat' do
  before do
    @requester = FactoryBot.create(:user, {email: 'newuser@email.com', first_name: 'new', last_name: 'user'})
    @category = FactoryBot.create :category
    @help = FactoryBot.create(:help, {
      title: 'This title',
      description: 'This is a very good description',
      category_id: @category.id,
      user_id: @requester.id,
      location: '23.8, 109.02'
    })
    @user = FactoryBot.create(:user)
    @token = TokenHelper.generate(@user)
  end
  
  
  it 'saves message to database' do
    post '/api/v1/chats', params: {message: 'hello', help_id: @help.id, user_id: @user.id}, headers: {'Authorization': 'Bearer ' + @token}
    expect(response).to have_http_status :created
    expect(JSON.parse(response.body).keys).to include("message", "user")
  end

  it 'fetches chats for specific help' do
    chat = FactoryBot.create(:chat, {
      help_id: @help.id,
      user_id: @user.id
    })
    get "/api/v1/chats/help/#{@help.id}", headers: {'Authorization': 'Bearer ' + @token}
    expect(response).to have_http_status :ok
    expect(JSON.parse(response.body).first.keys).to include("message", "user")
  end

  context 'when chatting' do

    before :each do
      @volunteer = FactoryBot.create :user, {email: 'new@email.com'}
      @volunteer_token = TokenHelper.generate(@volunteer)
    end

    it 'should increment fulfillment count of help if new user sends message' do
      post '/api/v1/chats', params: {message: 'hi', help_id: @help.id, user_id: @volunteer.id}, headers: {'Authorization': 'Bearer ' + @volunteer_token}
      expect(response).to have_http_status :created
      help = Help.find(@help.id)
      expect(help.fulfilment_count).to be 1
    end

    it 'should not increment fulfillment count if user has already sent a message' do
      help = FactoryBot.create(:help, {
        title: 'Another title',
        description: 'This is a very good description',
        category_id: @category.id,
        user_id: @user.id,
        location: '23.8, 109.02',
        fulfilment_count: 1
      })
      FactoryBot.create :chat, {help_id: help.id, user_id: @volunteer.id}
      post '/api/v1/chats', params: {message: 'hello', help_id: help.id, user_id: @volunteer.id}, headers: {'Authorization': 'Bearer ' + @volunteer_token}
      saved_help = Help.find(help.id)
      expect(saved_help.fulfilment_count).to be 1
    end

    it 'should not increment fulfilment count if user is the requester' do
      post '/api/v1/chats', params: {message: 'I need help', help_id: @help.id, user_id: @requester.id}, headers: {'Authorization': 'Bearer ' + @token}
      saved_help = Help.find(@help.id)
      expect(saved_help.fulfilment_count).to be 0
    end

    it 'should mark help as complete if fulfilment count is equal to 5' do
      @volunteer2 = FactoryBot.create :user, {email: 'volunteer@email.com'}
      @volunteer2_token = TokenHelper.generate(@volunteer2)
      help = FactoryBot.create(:help, {
        fulfilment_count: 4,
        category_id: @category.id,
        user_id: @user.id,
      })
      post '/api/v1/chats', params: {message: 'hello', help_id: help.id, user_id: @volunteer2.id}, headers: {'Authorization': 'Bearer ' + @volunteer2_token}
      saved_help = Help.find(help.id)
      expect(saved_help.fulfilment_count).to be 5
      expect(saved_help.status).to be true
    
    end
  end
end