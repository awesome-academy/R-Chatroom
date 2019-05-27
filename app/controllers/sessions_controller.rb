class SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: [:destroy]
  before_action :set_user, only: [:create]
  skip_before_action :verify_signed_out_user

  def create
    if @user.valid_password? user_params[:password]
      render :create_success, status: :created
    else
      @error_message = I18n.t "wrong_password"
      render :create_error, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      current_user.update_attribute :authentication_token, nil
      sign_out current_user
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
