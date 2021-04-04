include TokenHelper

class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      token = TokenHelper.generate user
      render json: {message: 'User created successfully', token: token}, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private def user_params
    params.permit(:first_name, :last_name, :email, :password, :government_id)
  end
end
