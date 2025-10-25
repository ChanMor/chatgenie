class Admin::ReservationsController < Admin::BaseController
  def index
    # Eager load user and table to prevent N+1 query problems
    @reservations = Reservation.includes(:user, :table)
                               .where('reservation_time >= ?', Time.current)
                               .order(:reservation_time)
  end
end