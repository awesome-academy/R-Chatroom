class AccountActivationsController < ApplicationController
  def activate
    @user = User.find_by id: params[:user_id]
    if @user && !@user.activated? && @user.valid_activation_token?(params[:token])
      @user.activate
      @user.reroll_token
      render :"sessions/create_success", status: :accepted
    elsif @user && @user.activated?
      @error_message = I18n.t "already_activated"
      render :error, status: :unprocessable_entity
    else
      @error_message = I18n.t "something_wrong"
      render :error, status: :unprocessable_entity
    end
  end
end
