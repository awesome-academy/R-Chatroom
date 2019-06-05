class SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: [:destroy], fallback: :none
  before_action :set_user, only: [:create]
  skip_before_action :verify_signed_out_user

  def create
    if @user.valid_password? user_params[:password]
      if @user.confirmed_at.present?
        render :create_success, status: :created
      else
        @error_message = I18n.t "not_activated"
        render :create_error, status: :precondition_failed
      end
    else
      @error_message = I18n.t "wrong_password"
      render :create_error, status: :unprocessable_entity
    end
  end

  def destroy
    return render :error, status: :unauthorized if cannot? :manage, current_user

    if current_user
      current_user.update_attribute :authentication_token, nil
      render :success, status: :ok
    else
      render :error, status: :unauthorized
    end
  end

  private
  def set_user
    @user = User.find_by user_name: user_params[:user_name]
    render :create_error, status: :unprocessable_entity unless @user
  end

  def user_params
    params.require(:user).permit :user_name, :password
  end
end
