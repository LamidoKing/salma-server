include TokenHelper

class Api::V1::AuthController < ApplicationController
  def login
    if params[:email].empty? || params[:password].empty?
      return render json: {message: 'Invalid login credentials'}, status: :unprocessable_entity
    end

    user = User.find_by_email(params[:email])

    if user &. authenticate(params[:password])
      token = TokenHelper.generate user
      render json: {token: token}, status: :ok
    else
      render json: {message: 'Invalid login credentials'}, status: :unauthorized
    end
  end

end
