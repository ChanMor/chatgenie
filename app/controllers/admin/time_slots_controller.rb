module Admin
  class TimeSlotsController < BaseController
    before_action :set_time_slot, only: [:edit, :update, :destroy]

    def index
      @time_slots = TimeSlot.order(start_time: :desc)
    end

    def new
      @time_slot = TimeSlot.new
    end

    def create
      @time_slot = TimeSlot.new(time_slot_params)
      
      if @time_slot.save
        redirect_to admin_time_slots_path, notice: "Time slot was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # The before_action already finds @time_slot
    end

    def update
      if @time_slot.update(time_slot_params)
        respond_to do |format|
          format.html { redirect_to admin_time_slots_path, notice: "Time slot was successfully updated." }
          format.json { render json: { success: true, message: "Time slot updated successfully" } }
        end
      else
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: { success: false, error: @time_slot.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if @time_slot.reservations.any?
        redirect_to admin_time_slots_path, alert: "Cannot delete time slot with existing reservations."
      else
        @time_slot.destroy
        redirect_to admin_time_slots_path, notice: "Time slot was successfully deleted."
      end
    end

    private

    def set_time_slot
      @time_slot = TimeSlot.find(params[:id])
    end

    def time_slot_params
      params.require(:time_slot).permit(:start_time, :max_tables, :table_capacity)
    end
  end
end
