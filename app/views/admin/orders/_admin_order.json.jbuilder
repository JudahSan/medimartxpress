# frozen_string_literal: true

json.extract! admin_order, :id, :customer_email, :fulfilled, :total, :created_at, :updated_at
json.url admin_order_url(admin_order, format: :json)
