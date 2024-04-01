# Seed Admin
admin_email = "admin@admin.com"
unless Admin.exists?(email: admin_email)
  Admin.create!(email: admin_email, password: "adminpassword")
  puts 'Admin user created.'
else
  puts 'Admin user already exists.'
end

# Seed Users
users = [
  {
    email: "jane.doe@example.com",
    password: '123456',
    first_name: "Jane",
    last_name: "Doe",
    address: "123 Main St",
    credit_card_info: "4111111111111111",
    role: 0
  },
# Include other users as needed...
]

users.each do |user_attrs|
  user = User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.first_name = user_attrs[:first_name]
    user.last_name = user_attrs[:last_name]
    user.address = user_attrs[:address]
    user.credit_card_info = user_attrs[:credit_card_info]
    user.role = user_attrs[:role]
  end
  puts "User #{user.email} seeded."
end

# Assuming user ID 1 should be linked to the packages.
# Make sure this user exists or adjust according to your needs.
user_for_packages = User.find_by(id: 1) || users.first

categories = {}
categories_data = [
  { name: "Gourmet Food & Beverages", description: "This category includes gourmet food items..." },
# ... other categories
]

categories_data.each do |cat_attrs|
  category = Category.find_or_create_by!(name: cat_attrs[:name]) do |c|
    c.description = cat_attrs[:description]
  end
  categories[category.name] = category.id
end
puts 'Categories seeded.'

# Seed Packages, ensuring we reference the newly created categories
packages_data = [
  { name: "Television1", description: "TV", price: 200, active: 0, weight: 40, dimensions: "120x120x30", category_name: "Gourmet Food & Beverages" },
# ... other packages
]

packages_data.each do |pkg_attrs|
  Package.create!(
    name: pkg_attrs[:name],
    description: pkg_attrs[:description],
    price: pkg_attrs[:price],
    category_id: categories[pkg_attrs[:category_name]], # Lookup the category ID by name
    active: pkg_attrs[:active],
    user_id: user_for_packages.id, # Associate with the user
    weight: pkg_attrs[:weight],
    dimensions: pkg_attrs[:dimensions]
  )
end
puts 'Packages seeded.'
default_driver_email = "default.driver@example.com"
default_driver = User.find_or_create_by!(email: default_driver_email) do |user|
  user.password = 'defaultpassword'
  user.first_name = "Default"
  user.last_name = "Driver"
  user.address = "address"
  user.credit_card_info = "424242424242"
  user.role = 1
end
puts 'Default driver seeded.'


# Seed Categories as previously described...

# Seed Packages, ensuring we reference the newly created categories as previously described...

# Seed a default delivery
# Replace the following attribute values with ones that are appropriate for your Delivery model
default_delivery_attributes = {
  # client_id: default_client.id, # Uncomment or modify this line if your model associates deliveries directly with clients
  driver_id: default_driver.id,
  driver_email: "default.driver@example.com",
  departure_city: "City A",
  arrival_city: "City B",
  departure_date: Date.today,
  arrival_date: Date.today + 5.days,
  total: 0}

default_delivery = Delivery.find_or_create_by!(default_delivery_attributes) do |delivery|
  # If you need to set attributes that are not part of the unique lookup, set them here.
end

puts 'Default delivery seeded.'
# Seed Deliveries, DeliveryPackages, Messages, and Reviews
# Follow a similar pattern to the above, ensuring you reference existing or newly created records appropriately.

puts 'All data seeded.'
