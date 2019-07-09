class UsersController < ApplicationController
  before_action :authenticate_user,  only: [:index, :update, :check]
  before_action :authorize_delete, only: [:destroy]
  before_action :authorize,          only: [:update]

  def index
    render json: {status: 200, msg: 'Logged-in'}
  end

  def check
    current_user.update!(last_login: Time.now)
    #render json: { user: current_user, answer: true, status: 200 }
    render json: { id: current_user.id, username: current_user.username }
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { status: 200, msg: 'User details have been updated.' }
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { status: 200, msg: 'User has been deleted.' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def authorize
    return_unauthorized unless current_user && current_user.can_modify_user?(params[:id])
  end
end
