class SessionsController < ApplicationController
  before_action :set_user, only: [:create, :destroy]

  def create
    if @user.authenticate session_params[:password]
      @user.reroll_token
      render :create_success, status: :created
    else
      render :create_error, status: :unprocessable_entity
    end
  end

  def destroy
    @user.reroll_token
    render json: {ok: "ok"}, status: :ok
  end

  private
  def set_user
    @user = User.find_by user_name: session_params[:user_name]
    render :create_error, status: :unprocessable_entity unless @user
  end

  def session_params
    params.require(:session).permit :user_name, :password
  end
end
