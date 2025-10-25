module Admin
  class BaseController < ApplicationController
    # Ensure every action in every admin controller runs this security check first
    before_action :require_admin

    private

    # This is our authorization logic
    def require_admin
      # Redirect to the main site's root unless the user is logged in AND is an admin
      unless current_user&.admin?
        redirect_to root_path, alert: "Access Denied: You are not authorized to view this page."
      end
    end
  end
end