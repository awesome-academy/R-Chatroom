class UsersController < ApplicationController
  before_action :find_authenticated_user, only: [:show]
  before_action :set_user, only: [:show]
  before_action :check_authorization, only: [:show]

  def index
    @users = User.all
  end

  def show
  end

  def create
    @user = User.new user_params

    if @user.save
      render :show, status: :created, location: @user
    else
      render :create_error, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_by id: params[:id]
      if !@user
        render :show_error, status: :unprocessable_entity
      end
    end

    def user_params
      params.require(:user).permit :user_name, :show_name, :password, :password_confirmation, :email
    end
end
