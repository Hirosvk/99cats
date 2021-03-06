class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def log_in(user)
    user.reset_session_token!
    @current_user = user
    session[:session_token] = user.session_token
  end

  def log_out
    current_user.reset_session_token! unless current_user.nil?
    session[:session_token] = nil
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def require_current_user!
    redirect_to cats_url if current_user.nil?
  end

  helper_method :current_user
end
