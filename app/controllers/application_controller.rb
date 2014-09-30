class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def assert_user_is_active
    return if current_user.is_active?
    sign_out :user
    redirect_to new_user_session_path, notice: "Sorry, Your account hasn't been accepted yet."
  end
end
