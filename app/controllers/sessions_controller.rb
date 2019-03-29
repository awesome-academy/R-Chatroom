class SessionsController < ApplicationController
  def create
    @user = User.find_by user_name: session_params[:user_name]
    if @user&.authenticate session_params[:password]
      @user.reroll_token
      render :create_success, status: :created
    else
      render :create_error, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
    def session_params
      params.require(:session).permit :user_name, :password
    end
end
