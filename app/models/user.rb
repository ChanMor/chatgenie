require 'uri'

class User < ApplicationRecord
  # Adds methods to set and authenticate against a BCrypt password.
  # This single line gives us the following:
  # - The ability to save a securely hashed password_digest attribute to the database.
  # - A pair of virtual attributes (password and password_confirmation) that we can use in our forms.
  # - An authenticate method that returns the user when the password is correct, and false otherwise.
  has_secure_password

  # A Rails enum maps an integer in the database to a set of named values.
  # This makes the code more readable and provides helpful methods.
  enum :role, { customer: 0, admin: 1 }

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end