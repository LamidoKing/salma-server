require 'rails_helper'
include TokenHelper

describe 'Help' do
  before do
    @help_url = '/api/v1/helps'
    @category = FactoryBot.create :category
    @help_data = {
      title: 'This title',
      description: 'This is a very good description',
      category_id: @category.id,
      user_id: 1,
      location: '23.8, 109.02',
      long: 23.09,
      lat: 109.02
    }
  end

  context 'Create new' do
    it 'returns unauthorized if user authorization header is missing' do
      post @help_url, params: @help_data, headers: {}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if user authorization header is invalid' do
      post @help_url, params: @help_data, headers: {'Authorization': '$2y$12ies.kdko380er.30urjohfo0'}
      expect(response).to have_http_status(:unauthorized)
    end

    context 'Authorized user' do
      before(:each) do
        @user = FactoryBot.create(:user)
        @token = TokenHelper.generate(@user)
      end

      it 'return unprocessable_entity error (422) when required fields are not present' do
        post @help_url, params: {}, headers: {'Authorization': 'Bearer ' + @token}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'creates help and returns 201 created' do
        # @help_data['user_id'] = @user.id
        expect {
          post @help_url, params: @help_data, headers: {'Authorization': 'Bearer ' + @token}
        }.to change {Help.count}.from(0).to(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'Fetch helps' do
      it 'returns unauthorized if user authorization header is missing' do
        get @help_url, headers: {}
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized if user authorization header invalid' do
        get @help_url, headers: {'Authorization': 'Bearer 84804i5.fjhroer.urierier'}
        expect(response).to have_http_status(:unauthorized)
      end
      context 'Valid Authentication' do
        before :each do
          @user = FactoryBot.create(:user)
          @token = TokenHelper.generate(@user)
        end

        it 'returns a list of unfulfilled helps with valid authorization' do
          @help_data['user_id'] = @user.id
          @help_data['fulfilment_count'] = 5
          FactoryBot.create :help, @help_data
          FactoryBot.create :help,  {user_id: @user.id, category_id: @category.id}
          get @help_url, headers: {'Authorization': 'Bearer ' + @token}
          expect(response).to have_http_status(:ok)
          help_object = JSON.parse(response.body)
          expect(help_object.count).to eq 1
          expect(help_object.first.keys).to include("title", "user", "category")
          # expect(help_object.first.user.count).to eq 1
        end

        it 'returns a list of unfulfilled helps by coordinates' do
          @help_data['user_id'] = @user.id
          @help_data['fulfilment_count'] = 5
          FactoryBot.create :help, @help_data
          FactoryBot.create :help,  {user_id: @user.id, category_id: @category.id, long: 10.1, lat: 2.1}
          FactoryBot.create :help,  {user_id: @user.id, category_id: @category.id, long: 101.1, lat: 21.1}
          get "#{@help_url}?coordinates=true&topLat=3&bottomLat=2&leftLong=10&rightLong=11", headers: {'Authorization': 'Bearer ' + @token}
          expect(response).to have_http_status(:ok)
          help_object = JSON.parse(response.body)
          expect(help_object.count).to eq 1
          expect(help_object.first.keys).to include("title", "user", "category")
          # expect(help_object.first.user.count).to eq 1
        end

        it 'returns help by id' do
          @help_data['user_id'] = @user.id
          FactoryBot.create :help, @help_data
          get "#{@help_url}/#{@help_data['id']}", headers: {'Authorization': 'Bearer ' + @token}
          expect(response).to have_http_status(:ok)
          help_object = JSON.parse(response.body)
          expect(help_object.first.keys).to include("title", "user", "category")
        end

        it 'returns only logged in user\'s own helps' do
          @help_data['user_id'] = @user.id
          FactoryBot.create :help, @help_data
          user2 = FactoryBot.create :user, {
            first_name: 'Ola',
            last_name: 'Kay',
            email: 'kay@email.com',
            password: 'abcdefg',
            government_id: 'image.jpg'
          }
          help_data2 = {
            title: 'Second help',
            description: 'This is a very good description',
            category_id: @category.id,
            user_id: user2.id,
            location: '33.2, 103.02'
          }
          FactoryBot.create :help, help_data2
          get @help_url + '/me', headers: {'Authorization': 'Bearer ' + @token}
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).count).to eq 1
          expect(JSON.parse(response.body).first.keys).to include("title", "category")
        end
      end
    end
  end
  it 'should turn help status to false and fulfilment_count to 4' do
    user = FactoryBot.create(:user)
    token = TokenHelper.generate(user)
    @help_data['fulfilment_count'] = 5
    @help_data['status'] = true
    @help_data['user_id'] = user.id
    help = FactoryBot.create(:help, @help_data)
    post '/api/v1/helps/reopen', params: {id: help.id}, headers: {'Authorization': 'Bearer ' + token}
    expect(response).to have_http_status :created
    saved_help = Help.find(help.id)
    expect(saved_help.status).to be(false)
    expect(saved_help.fulfilment_count).to be(4)
  end
end