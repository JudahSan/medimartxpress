# frozen_string_literal: true

class AdminController < ApplicationController
  layout "admin"
  # require user authentication
  before_action :authenticate_admin!

  def index
    # fetch last 5 unfulfilled orders
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)
    @quick_stats = {
      sales:        Order.where(created_at: Time.zone.now.midnight..Time.zone.now).count,
      revenue:      Order.where(created_at: Time.zone.now.midnight..Time.zone.now).sum(:total)&.round(),
      average_sale: Order.where(created_at: Time.zone.now.midnight..Time.zone.now).average(:total)&.round(),
      pre_sale:     OrderProduct.joins(:order).where(orders: { created_at: Time.zone.now.midnight..Time.zone.now }).average(:quantity)
    }
    @orders_by_day = Order.where("created_at > ?", 7.days.ago).order(:created_at)
    @orders_by_day = @orders_by_day.group_by { |order| order.created_at.to_date }
    @revenue_by_day = @orders_by_day.to_h do |day, orders|
      [day.strftime("%A"), orders.sum(&:total)]
    end
    return unless @revenue_by_day.count < 7

    days_of_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

    data_hash = @revenue_by_day.to_h
    current_day = Time.zone.today.strftime("%A")
    current_day_index = days_of_week.index(current_day)
    next_day_index = (current_day_index + 1) % days_of_week.length

    # Display current day last
    ordered_days_with_current_last = days_of_week[next_day_index..] + days_of_week[0...next_day_index]

    complete_ordered_array_with_current_last = ordered_days_with_current_last.map do |day|
      [day, data_hash.fetch(day, 0)]
    end
    @revenue_by_day = complete_ordered_array_with_current_last
  end
end
