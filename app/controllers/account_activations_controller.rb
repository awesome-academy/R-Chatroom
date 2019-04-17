class AccountActivationsController < ApplicationController
  def activate
    user = User.find_by id: params[:user_id]
    if user && !user.activated? && user.valid_activation_token?(params[:token])
      user.activate
      render :success, status: :accepted
    else
      render :error, status: :unprocessable_entity
    end
  end
end
