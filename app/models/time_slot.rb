class TimeSlot < ApplicationRecord
  has_many :reservations, dependent: :destroy
  
  validates :start_time, presence: true, uniqueness: true
  validates :max_tables, presence: true, numericality: { greater_than: 0 }
  validates :table_capacity, presence: true, numericality: { greater_than: 0 }
  
  # Validate that time slot is in the future (at least 2 hours from now)
  validate :start_time_must_be_in_future, on: :create
  
  # Scope to get upcoming time slots
  scope :upcoming, -> { where('start_time >= ?', Time.current).order(:start_time) }
  scope :past, -> { where('start_time < ?', Time.current).order(start_time: :desc) }
  
  # Check if this time slot has available tables
  def available_tables_count
    max_tables - reservations.count
  end
  
  def available?
    available_tables_count > 0
  end
  
  # Format for display
  def formatted_time
    start_time.strftime("%B %d, %Y at %l:%M %p")
  end
  
  def date
    start_time.to_date
  end
  
  private
  
  def start_time_must_be_in_future
    if start_time.present? && start_time < Time.current
      errors.add(:start_time, "cannot be in the past")
    end
  end
end
