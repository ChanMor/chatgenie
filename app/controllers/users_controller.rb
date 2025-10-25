class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_reservation_path, notice: 'Account successfully created! You can now make a reservation.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Add :first_name, :last_name, and :contact_number to the list of permitted attributes
    params.require(:user).permit(:first_name, :last_name, :contact_number, :email, :password, :password_confirmation)
  end
end