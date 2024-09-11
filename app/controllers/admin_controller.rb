# frozen_string_literal: true

# Manages administrative actions within the admin dashboard.
class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  # Displays the admin dashboard with summary statistics and recent orders.
  #
  # Retrieves the last 5 unfulfilled orders, current day's sales, revenue, and average sale,
  # as well as revenue grouped by day for the past week.
  #
  # @return [void]
  def index
    @orders = recent_unfulfilled_orders
    @quick_stats = fetch_quick_stats
    @revenue_by_day = fetch_revenue_by_day
  end

  private

  # Retrieves the last 5 unfulfilled orders.
  #
  # @return [ActiveRecord::Relation] the last 5 unfulfilled orders
  def recent_unfulfilled_orders
    Order.where(fulfilled: false)
         .order(created_at: :desc)
         .take(5)
  end

  # Retrieves quick statistics for the current day.
  #
  # @return [Hash] a hash containing sales, revenue, average sale, and pre-sale statistics
  def fetch_quick_stats
    today = Time.zone.now.midnight
    {
      sales:        calculate_sales(today),
      revenue:      calculate_revenue(today),
      average_sale: calculate_average_sale(today),
      pre_sale:     calculate_pre_sale(today)
    }
  end

  # Calculates sales for the current day.
  #
  # @param today [Time] the start of the current day
  # @return [Integer] the number of sales
  def calculate_sales(today)
    Order.where(created_at: today..Time.zone.now).count
  end

  # Calculates revenue for the current day.
  #
  # @param today [Time] the start of the current day
  # @return [Integer] the total revenue rounded
  def calculate_revenue(today)
    Order.where(created_at: today..Time.zone.now)
         .sum(:total)&.round
  end

  # Calculates average sale for the current day.
  #
  # @param today [Time] the start of the current day
  # @return [Integer] the average sale rounded
  def calculate_average_sale(today)
    Order.where(created_at: today..Time.zone.now)
         .average(:total)&.round
  end

  # Calculates pre-sale quantity for the current day.
  #
  # @param today [Time] the start of the current day
  # @return [Float] the average quantity of pre-sale items
  def calculate_pre_sale(today)
    OrderProduct.joins(:order)
                .where(orders: { created_at: today..Time.zone.now })
                .average(:quantity)
  end

  # Retrieves revenue grouped by day for the past week and formats it.
  #
  # @return [Array<Array>] an array of arrays containing day names and corresponding revenue
  def fetch_revenue_by_day
    orders_by_day = Order.where("created_at > ?", 7.days.ago)
                         .order(:created_at)
                         .group_by { |order| order.created_at.to_date }

    revenue_by_day = orders_by_day.to_h do |day, orders|
      [day.strftime("%A"), orders.sum(&:total)]
    end

    return format_revenue_by_day(revenue_by_day) if revenue_by_day.count < 7

    revenue_by_day
  end

  # Formats revenue by day to display the current day last.
  #
  # @param revenue_by_day [Hash] a hash containing day names and corresponding revenue
  # @return [Array<Array>] an array of arrays containing day names and corresponding revenue
  def format_revenue_by_day(revenue_by_day)
    days_of_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    data_hash = revenue_by_day.to_h
    current_day = Time.zone.today.strftime("%A")
    current_day_index = days_of_week.index(current_day)
    next_day_index = (current_day_index + 1) % days_of_week.length

    # Display current day last
    ordered_d_with_current_last = days_of_week[next_day_index..] + days_of_week[0...next_day_index]

    ordered_d_with_current_last.map do |day|
      [day, data_hash.fetch(day, 0)]
    end
  end
end
