class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    @user = User.confirm_by_token params[:confirmation_token]
    if @user.errors.empty?
      render :"sessions/create_success", status: :accepted
    else
      render :error, status: :unprocessable_entity
    end
  end
end
