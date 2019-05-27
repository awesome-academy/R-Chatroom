class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new user_params
    if @user.save
      render :"users/show", status: :created, location: @user
    else
      render :"users/create_error", status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation,
      :user_name, :show_name
  end
end
