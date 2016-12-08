class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: 'Facebook', reason: 'Email is already registered') if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: 'Google', reason: 'Email is already registered') if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:alert] = 'Permission denied'
    redirect_to root_path
  end
end
