json.extract! admin_stock, :id, :product_id, :amount, :size, :created_at, :updated_at
json.url admin_stock_url(admin_stock, format: :json)
