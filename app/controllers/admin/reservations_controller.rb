module Admin
  class ReservationsController < BaseController
    before_action :set_reservation, only: [:update, :destroy]
    
    def index
      # Start with a base scope to prevent N+1 queries
      @reservations = Reservation.includes(:user, :time_slot)

      # Filter by date if a date is provided in the params
      if params[:filter_date].present?
        filter_day = Date.parse(params[:filter_date])
        @reservations = @reservations.for_date(filter_day)
      end

      # Always order the results by time slot start time
      @reservations = @reservations.joins(:time_slot).order('time_slots.start_time ASC')
    end

    def update
      # Update both reservation and user contact number
      if params[:reservation][:contact_number].present?
        @reservation.user.update(contact_number: params[:reservation][:contact_number])
      end
      
      if @reservation.update(reservation_params.except(:contact_number))
        render json: { success: true, message: "Reservation updated successfully" }
      else
        render json: { success: false, error: @reservation.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end

    def destroy
      if @reservation.destroy
        respond_to do |format|
          format.html { redirect_to admin_reservations_path, notice: "Reservation was successfully cancelled." }
          format.json { render json: { success: true, message: "Reservation cancelled successfully" } }
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_reservations_path, alert: "Failed to cancel reservation." }
          format.json { render json: { success: false, error: "Failed to cancel reservation" }, status: :unprocessable_entity }
        end
      end
    end
    
    private
    
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
    
    def reservation_params
      params.require(:reservation).permit(:party_size, :contact_number)
    end
  end
end