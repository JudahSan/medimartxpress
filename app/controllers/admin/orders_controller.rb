# frozen_string_literal: true

# Admin::OrdersController manages the administrative actions related to orders.
# This includes displaying a list of orders, showing details for a specific order,
# creating new orders, updating existing orders, and deleting orders.
#
# Actions:
# - index: Lists all orders, separated into fulfilled and not fulfilled.
# - show: Displays details of a specific order.
# - new: Initializes a new order form.
# - edit: Prepares an existing order for editing.
# - create: Handles the creation of a new order.
# - update: Updates an existing order's attributes.
# - destroy: Deletes an existing order.
class Admin::OrdersController < AdminController
  before_action :set_admin_order, only: %i[show edit update destroy]

  # GET /admin/orders or /admin/orders.json
  def index
    # split order based on fulfilled status
    @not_fulfilled_pagy, @not_fulfilled_orders = pagy(Order.where(fulfilled: false).order(created_at: :asc))
    @fulfilled_pagy, @fulfilled_orders = pagy(Order.where(fulfilled: true).order(created_at: :asc), page_param: :page_fulfilled)
  end

  # GET /admin/orders/1 or /admin/orders/1.json
  def show; end

  # GET /admin/orders/new
  def new
    @admin_order = Order.new
  end

  # GET /admin/orders/1/edit
  def edit; end

  # POST /admin/orders or /admin/orders.json
  def create
    @admin_order = Order.new(admin_order_params)

    respond_to do |format|
      if @admin_order.save
        format.html do
          redirect_to admin_order_url(@admin_order), notice: t("order_controller.create.success")
        end
        format.json { render :show, status: :created, location: @admin_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/orders/1 or /admin/orders/1.json
  def update
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        format.html do
          redirect_to admin_order_url(@admin_order), notice: t("order_controller.update.success")
        end
        format.json { render :show, status: :ok, location: @admin_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/orders/1 or /admin/orders/1.json
  def destroy
    @admin_order.destroy!

    respond_to do |format|
      format.html { redirect_to admin_orders_url, notice: t("order_controller.destroy.success") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_order
    @admin_order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_order_params
    params.require(:order).permit(:customer_email, :fulfilled, :total, :address)
  end
end
