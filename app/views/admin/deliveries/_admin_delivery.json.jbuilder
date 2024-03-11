json.extract! admin_delivery, :id, :client_email, :driver_email, :fulfilled, :total, :address, :created_at, :updated_at
json.url admin_delivery_url(admin_delivery, format: :json)
