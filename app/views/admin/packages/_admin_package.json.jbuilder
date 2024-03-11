json.extract! admin_package, :id, :name, :description, :price, :category_id, :active, :created_at, :updated_at
json.url admin_package_url(admin_package, format: :json)
