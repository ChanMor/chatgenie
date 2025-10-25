class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    # The .authenticate method is provided by has_secure_password
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if user.admin?
        # If the user is an admin, redirect to the admin dashboard
        redirect_to admin_root_path, notice: 'Logged in successfully as Admin.'
      else
        # If the user is a customer, redirect to their reservations page
        redirect_to reservations_path, notice: 'Logged in successfully.'
      end

    else
      flash.now[:alert] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out'
  end
end