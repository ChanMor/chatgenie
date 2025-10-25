# Note the module declaration, which matches the directory structure
class Admin::BaseController < ApplicationController
  # Set the layout for all admin controllers
  layout 'application'

  # Use the require_admin helper we defined in ApplicationController
  before_action :require_admin
end