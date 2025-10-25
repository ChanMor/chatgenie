class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot

  # Add validations to ensure data integrity
  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :table_capacity, numericality: { greater_than: 0 }, allow_nil: true
  
  # Validate that party_size doesn't exceed table_capacity
  validate :party_size_within_table_capacity, if: -> { table_capacity.present? }
  
  # Scopes
  scope :upcoming, -> { joins(:time_slot).where('time_slots.start_time >= ?', Time.current).order('time_slots.start_time ASC') }
  scope :past, -> { joins(:time_slot).where('time_slots.start_time < ?', Time.current).order('time_slots.start_time DESC') }
  scope :for_date, ->(date) { joins(:time_slot).where('DATE(time_slots.start_time) = ?', date) }
  
  # Check if reservation can be cancelled (2 hours before)
  def cancellable?
    time_slot.present? && time_slot.start_time > Time.current + 2.hours
  end
  
  # Delegation for easier access
  delegate :start_time, to: :time_slot, prefix: true, allow_nil: true
  
  private
  
  def party_size_within_table_capacity
    if party_size > table_capacity
      errors.add(:party_size, "cannot exceed table capacity of #{table_capacity}")
    end
  end
end