class ReservationsController < ApplicationController
  # Use our login filter to protect all actions in this controller
  before_action :require_login
  before_action :set_reservation, only: [:destroy]

  def index
    # User dashboard - show only their own reservations
    @reservations = current_user.reservations
                                .includes(:time_slot)
                                .upcoming
  end

  def new
    # Monthly calendar view
    if params[:date]
      @current_date = Date.parse(params[:date])
    elsif params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today
    end
    
    # If a specific date is selected, show time slots for that day
    if params[:date]
      @selected_date = @current_date
      # Show all time slots for the day (including past and too soon)
      @time_slots = TimeSlot.includes(:reservations)
                            .where(start_time: @selected_date.beginning_of_day..@selected_date.end_of_day)
                            .order(:start_time)
    else
      # Show monthly calendar
      @start_of_month = @current_date.beginning_of_month
      @end_of_month = @current_date.end_of_month
      
      # Get ALL time slots for the month to determine which days have slots
      all_time_slots = TimeSlot.includes(:reservations)
                               .where(start_time: @start_of_month.beginning_of_day..@end_of_month.end_of_day)
      
      minimum_time = Time.current + 2.hours
      
      # Group by date and calculate availability status for each day
      @calendar_data = {}
      all_time_slots.group_by { |slot| slot.start_time.to_date }.each do |date, slots|
        # Check if any slot is bookable (available AND more than 2 hours away)
        bookable_count = slots.count { |slot| slot.available? && slot.start_time >= minimum_time }
        
        if bookable_count > 0
          @calendar_data[date] = 'available'
        else
          # Has slots but all are either full, past, or too soon
          @calendar_data[date] = 'full'
        end
      end
    end
  end
  
  def show_slot
    @time_slot = TimeSlot.find(params[:time_slot_id])
    @reservation = current_user.reservations.build(
      time_slot: @time_slot,
      party_size: params[:party_size] || 2
    )
  end

  def create
    @time_slot = TimeSlot.find(params[:reservation][:time_slot_id])
    
    # Check if time slot is still available
    unless @time_slot.available?
      redirect_to new_reservation_path, alert: "Sorry, this time slot is no longer available."
      return
    end
    
    # Check if reservation is at least 2 hours in advance
    if @time_slot.start_time < Time.current + 2.hours
      redirect_to new_reservation_path, alert: "Reservations must be made at least 2 hours in advance."
      return
    end
    
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.time_slot = @time_slot
    @reservation.table_capacity = @time_slot.table_capacity
    
    if @reservation.save
      redirect_to reservations_path, notice: "Reservation successfully created!"
    else
      render :show_slot, status: :unprocessable_entity
    end
  end

  def destroy
    # Authorization: Ensure the reservation belongs to the current user
    if @reservation.user != current_user
      redirect_to reservations_path, alert: "Not authorized."
      return
    end

    # Business Rule: Cannot cancel within 2 hours
    if @reservation.cancellable?
      @reservation.destroy
      redirect_to reservations_path, notice: "Reservation successfully cancelled."
    else
      redirect_to reservations_path, alert: "Cannot cancel a reservation within 2 hours of the booking time."
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:party_size, :time_slot_id)
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end