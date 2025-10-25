class ApplicationController < ActionController::Base
  # Make these methods available to all controllers and views
  helper_method :current_user, :logged_in?

  private

  def current_user
    # Find the user by the session ID, if it exists
    # Use ||= to cache the result, avoiding multiple database queries per request
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # A user is logged in if current_user returns a user object
    !!current_user
  end

  def require_login
    # A before_action filter to protect pages
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section."
      redirect_to login_path
    end
  end

  def require_admin
    # An authorization filter for admin-only sections
    # It first ensures a user is logged in, then checks their role
    unless logged_in? && current_user.admin?
      flash[:alert] = "You are not authorized to access this section."
      redirect_to root_path
    end
  end
end