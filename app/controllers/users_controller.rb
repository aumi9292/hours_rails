class UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create, :login]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def login
    user = User.find_by(email: user_params[:email].to_s.downcase)

    if user&.authenticate(user_params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def index
    render json: User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save && @user.authenticate(user_params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
