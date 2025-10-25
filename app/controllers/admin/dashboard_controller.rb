# Note that we are inside the Admin module
module Admin
  # IMPORTANT: Inherit from Admin::BaseController, not ApplicationController
  class DashboardController < BaseController
    def show
      @view_type = params[:view] || 'monthly'
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      
      case @view_type
      when 'daily'
        @start_date = @date
        @end_date = @date
      when 'weekly'
        @start_date = @date.beginning_of_week
        @end_date = @date.end_of_week
      when 'monthly'
        @start_date = @date.beginning_of_month
        @end_date = @date.end_of_month
      end
      
      # Get all time slots in the date range with their reservations
      @time_slots = TimeSlot.includes(:reservations => :user)
                            .where(start_time: @start_date.beginning_of_day..@end_date.end_of_day)
                            .order(:start_time)
      
      # Group TIME SLOTS (not individual reservations) by date for calendar view
      @time_slots_by_date = @time_slots.group_by { |slot| slot.start_time.to_date }
    end
  end
end