require 'rails_helper'
include TokenHelper

describe 'Users' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'Register' do
    it 'return unprocessable_entity error (422) when required fields are not present' do
      post '/api/v1/users', params: {}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'creates user in the database and returns 201' do
      expect {
        post '/api/v1/users', params: {
          first_name: 'Ola',
          last_name: 'Kunle',
          email: 'kunsal@email.com',
          password: 'abcdef',
          government_id: 'kdkkdkdkdkdkkd'
        }
      }.to change {User.count}.from(0).to(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).keys).to match_array(%w[token message])
    end
  end

  context 'Login' do
    before(:each) do
      user = FactoryBot.create(:user)
      @credentials = {
        email: 'johndoe@email.com', password: 'password'
      }
    end

    it 'should return with error is email is not present' do
      @credentials['email'] = ''
      post '/api/v1/login', params: @credentials
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should return with error is password is not present' do
      @credentials['password'] = ''
      post '/api/v1/login', params: @credentials
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should return with unauthorized if email is not in database' do
      @credentials['email'] = 'kay@zmail.co'
      post '/api/v1/login', params: @credentials
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return with unauthorized if passwords do not match' do
      @credentials['password'] = 'abcdefg'
      post '/api/v1/login', params: @credentials
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should log user in with valid credential' do
      post '/api/v1/login', params: @credentials
      expect(response).to have_http_status(:success)
    end

    it 'should return token when login is successful' do
      post '/api/v1/login', params: @credentials
      expect(JSON.parse(response.body).keys).to match_array(%w[token])
    end
  end

  context 'Profile' do
    it 'should return unauthorized when authorization header is empty' do
      get '/api/v1/profile'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return unauthorized when authorization header is invalid' do
      get '/api/v1/profile', headers: {'Authorization': 'Bearer kdkdkdkdk'}
      expect(response).to have_http_status(:unauthorized)
    end

    context 'Valid token' do
      before(:each) do
        user = FactoryBot.create(:user)
        @token = TokenHelper.generate(user)
      end

      it 'should return ok status when authorization header is valid' do
        get '/api/v1/profile', headers: {'Authorization': 'Bearer ' + @token}
        expect(response).to have_http_status(:ok)
      end

      it 'should return user data with attributes' do
        get '/api/v1/profile', headers: {'Authorization': 'Bearer ' + @token}
        expect(JSON.parse(response.body).keys).to match_array(
          %w[id first_name last_name email government_id created_at updated_at]
        )
      end
    end

  end
end