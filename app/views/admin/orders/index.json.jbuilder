# frozen_string_literal: true

json.array! @admin_orders, partial: "admin_orders/admin_order", as: :admin_order
