class Users::RegistrationsController < Devise::RegistrationsController

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end