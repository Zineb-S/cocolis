# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Seed Admin
unless Admin.exists?(email: "admin@admin.com")
  Admin.create!(email: "admin@admin.com", password: "adminpassword")
  puts 'Admin user created'
else
  puts 'Admin user already exists'
end

# Seed Categories
unless Category.exists?
  10.times do |i|
    Category.create!(
      name: "Category ##{i+1}",
      description: "Description for category ##{i+1}"
    )
  end
  puts 'Categories seeded'
else
  puts 'Categories already exist'
end

# Seed Packages
if Package.count < 30
  30.times do |i|
    Package.create!(
      name: "Package ##{i+1}",
      description: "Description for package ##{i+1}",
      price: rand(100..1000),
      category_id: Category.order("RANDOM()").first.id, # Assign a random category
      active: [true, false].sample # Randomly assign active status
    )
  end
  puts 'Packages seeded'
else
  puts 'Packages count meets or exceeds 30'
end

# Seed Deliveries
if Delivery.count < 44
  44.times do |i|
    Delivery.create!(
      client_email: "client#{i+1}@example.com",
      driver_email: "driver#{i+1}@example.com",
      fulfilled: i < 22, # First 22 will be false, next 22 will be true
      total: rand(1000..5000),
      address: "123 Main St, City ##{i+1}"
    )
  end
  puts 'Deliveries seeded'
else
  puts 'Deliveries count meets or exceeds 44'
end

# Seed DeliveryPackages
if DeliveryPackage.count < 10
  10.times do |i|
    delivery = Delivery.order("RANDOM()").first
    package = Package.order("RANDOM()").first

    DeliveryPackage.create!(
      package_id: package.id,
      delivery_id: delivery.id,
      departureCity: "City Start #{i+1}",
      destinationCity: "City End #{i+1}",
      departureDate: "2024-03-#{rand(1..28).to_s.rjust(2, '0')}",
      arrivalDate: "2024-04-#{rand(1..28).to_s.rjust(2, '0')}",
      quantity: rand(1..5),
      weight: rand(1.0..100.0).round(2)
    )
  end
  puts 'DeliveryPackages seeded'
else
  puts 'DeliveryPackages count meets or exceeds 10'
end
