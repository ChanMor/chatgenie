class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :table

  # Add validations to ensure data integrity
  validates :reservation_time, presence: true
  validates :party_size, presence: true, numericality: { greater_than: 0 }
end