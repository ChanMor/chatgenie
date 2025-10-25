# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data (in development only)
if Rails.env.development?
  puts "Clearing existing data..."
  Reservation.destroy_all
  TimeSlot.destroy_all
  User.where.not(email: 'admin@example.com').destroy_all
end

# Create admin user
puts "Creating admin user..."
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.contact_number = '555-0001'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = :admin
end
puts "Admin created: #{admin.email} (password: password123)"

# Create sample customers
puts "\nCreating sample customers..."
customers = []
3.times do |i|
  customer = User.find_or_create_by!(email: "customer#{i+1}@example.com") do |user|
    user.first_name = "Customer#{i+1}"
    user.last_name = "Test"
    user.contact_number = "555-100#{i+1}"
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.role = :customer
  end
  customers << customer
  puts "Customer created: #{customer.email} (password: password123)"
end

# Create time slots for the next 14 days
puts "\nCreating time slots..."
start_date = Date.today
end_date = start_date + 14.days

(start_date..end_date).each do |date|
  # Create slots from 5 PM to 10 PM (hourly)
  (17..21).each do |hour|
    slot_time = date.to_datetime.change(hour: hour, min: 0, sec: 0)
    
    # Skip past time slots
    next if slot_time < Time.current
    
    # Vary the table capacity and max tables
    table_capacity = [2, 4, 6, 8].sample
    max_tables = [5, 8, 10, 12].sample
    
    TimeSlot.find_or_create_by!(start_time: slot_time) do |slot|
      slot.table_capacity = table_capacity
      slot.max_tables = max_tables
    end
  end
end
puts "Created #{TimeSlot.count} time slots"

# Create some sample reservations
puts "\nCreating sample reservations..."
sample_slots = TimeSlot.where('start_time > ?', Time.current).order(:start_time).limit(10)
sample_slots.each_with_index do |slot, index|
  next if index > 5 # Only book half of them
  
  customer = customers.sample
  party_size = rand(1..slot.table_capacity)
  
  Reservation.create!(
    user: customer,
    time_slot: slot,
    party_size: party_size,
    table_capacity: slot.table_capacity
  )
end
puts "Created #{Reservation.count} sample reservations"

puts "\n✅ Seeding complete!"
puts "\n📝 You can login with:"
puts "   Admin: admin@example.com / password123"
puts "   Customer: customer1@example.com / password123"
