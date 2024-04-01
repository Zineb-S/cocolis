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

# Seed Categories
categories_data = [
  { name: "Gourmet Food & Beverages", description: "This category includes gourmet food items..." },
# Include other categories as per your data...
]

categories_data.each do |cat_attrs|
  Category.find_or_create_by!(name: cat_attrs[:name]) do |category|
    category.description = cat_attrs[:description]
  end
end
puts 'Categories seeded.'

# Seed Packages
packages_data = [
  { name: "Television1", description: "TV", price: 200, category_id: 11, active: 0, weight: 40, dimensions: "120x120x30" },
# Include other packages as per your data...
]

packages_data.each do |pkg_attrs|
  Package.create!(
    name: pkg_attrs[:name],
    description: pkg_attrs[:description],
    price: pkg_attrs[:price],
    category_id: pkg_attrs[:category_id],
    active: pkg_attrs[:active],
    user_id: user_for_packages.id, # Associate with the user
    weight: pkg_attrs[:weight],
    dimensions: pkg_attrs[:dimensions]
  )
end
puts 'Packages seeded.'

# Seed Deliveries, DeliveryPackages, Messages, and Reviews
# Follow a similar pattern to the above, ensuring you reference existing or newly created records appropriately.

puts 'All data seeded.'
