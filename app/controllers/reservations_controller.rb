class ReservationsController < ApplicationController
  # Use our login filter to protect all actions in this controller
  before_action :require_login
  before_action :set_reservation, only: [:destroy]

  def index
    # User dashboard - show only their own upcoming reservations
    @reservations = current_user.reservations
                                .where('reservation_time >= ?', Time.current)
                                .order(:reservation_time)
  end

  def new
    @reservation = Reservation.new(party_size: 2) # Default party size
    @available_slots = find_available_slots(Time.zone.now.to_date)
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)

    # Find an available table for the requested time and party size
    available_tables = Table.where('capacity >= ?', @reservation.party_size)
                            .where.not(id: Reservation.where(reservation_time: @reservation.reservation_time).select(:table_id))
    
    if available_tables.any?
      @reservation.table = available_tables.first
      if @reservation.save
        redirect_to reservations_path, notice: "Reservation successfully created!"
      else
        # If reservation fails validation (e.g., party size is 0)
        @available_slots = find_available_slots(@reservation.reservation_time.to_date)
        render :new, status: :unprocessable_entity
      end
    else
      # If no tables are available
      flash.now[:alert] = "Sorry, no tables are available for that time and party size."
      @available_slots = find_available_slots(@reservation.reservation_time.to_date)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Authorization: Ensure the reservation belongs to the current user
    if @reservation.user != current_user
      redirect_to reservations_path, alert: "Not authorized."
      return
    end

    # Business Rule: Cannot cancel within 2 hours
    if @reservation.reservation_time > Time.current + 2.hours
      @reservation.destroy
      redirect_to reservations_path, notice: "Reservation successfully cancelled."
    else
      redirect_to reservations_path, alert: "Cannot cancel a reservation within 2 hours of the booking time."
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:reservation_time, :party_size)
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
  
  # This is a simplified helper to generate time slots. A real app might be more complex.
  def find_available_slots(date)
    start_of_day = date.to_datetime.change(hour: 17) # Restaurant opens at 5 PM
    end_of_day = date.to_datetime.change(hour: 22) # Last slot at 10 PM
    
    slots = []
    current_slot = start_of_day
    while current_slot < end_of_day
      slots << current_slot
      current_slot += 1.hour
    end
    slots
  end
end