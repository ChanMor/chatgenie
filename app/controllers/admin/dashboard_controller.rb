# Note that we are inside the Admin module
module Admin
  # IMPORTANT: Inherit from Admin::BaseController, not ApplicationController
  class DashboardController < BaseController
    def show
      # The show action is empty for now.
      # We will add logic to fetch data for the dashboard later.
    end
  end
end