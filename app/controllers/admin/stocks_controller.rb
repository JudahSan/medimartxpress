# frozen_string_literal: true

# Manages stock levels for products within the admin dashboard.
class Admin::StocksController < AdminController
  before_action :set_admin_stock, only: %i[show edit update destroy]

  # GET /admin/stocks or /admin/stocks.json
  # Displays a list of stocks for a specific product.
  #
  # @return [void]
  def index
    @admin_stocks = Stock.where(product_id: params[:product_id])
  end

  # GET /admin/stocks/1 or /admin/stocks/1.json
  # Displays a specific stock item.
  #
  # @return [void]
  def show; end

  # GET /admin/stocks/new
  # Initializes a new stock item form for a specific product.
  #
  # @return [void]
  def new
    @product = Product.find(params[:product_id])
    @admin_stock = Stock.new
  end

  # GET /admin/stocks/1/edit
  # Initializes the edit form for a specific stock item.
  #
  # @return [void]
  def edit
    @product = Product.find(params[:product_id])
    @admin_stock = Stock.find(params[:id])
  end

  # POST /admin/stocks or /admin/stocks.json
  # Creates a new stock item for a product.
  #
  # @return [void]
  def create
    @product = Product.find(params[:product_id])
    @admin_stock = @product.stocks.new(admin_stock_params)

    respond_to do |format|
      if save_stock
        handle_success(format)
      else
        handle_failure(format)
      end
    end
  end

  # PATCH/PUT /admin/stocks/1 or /admin/stocks/1.json
  # Updates an existing stock item.
  #
  # @return [void]
  def update
    respond_to do |format|
      if @admin_stock.update(admin_stock_params)
        format.html do
          redirect_to admin_product_stock_url(@admin_stock.product, @admin_stock),
                      notice: t("stock_categories.update.success")
        end
        format.json { render :show, status: :ok, location: @admin_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/stocks/1 or /admin/stocks/1.json
  # Deletes an existing stock item.
  #
  # @return [void]
  def destroy
    @admin_stock.destroy!

    respond_to do |format|
      format.html do
        redirect_to admin_product_stocks_url, notice: t("stock_categories.destroy.success")
      end
      format.json { head :no_content }
    end
  end

  private

  # Sets up the stock item for use in actions.
  #
  # @return [void]
  def set_admin_stock
    @admin_stock = Stock.find(params[:id])
  end

  # Only allows a list of trusted parameters through.
  #
  # @return [ActionController::Parameters]
  def admin_stock_params
    params.require(:stock).permit(:amount, :size)
  end

  # Attempts to save the stock item.
  #
  # @return [Boolean] true if the stock item was successfully saved, false otherwise
  def save_stock
    @admin_stock.save
  end

  # Handles successful stock item creation.
  #
  # @param format [ActionDispatch::Http::MimeNegotiation::Formatter] the response format
  # @return [void]
  def handle_success(format)
    format.html do
      redirect_to admin_product_stock_url(@product, @admin_stock),
                  notice: t("stock_categories.create.success")
    end
    format.json { render :show, status: :created, location: @admin_stock }
  end

  # Handles failed stock item creation.
  #
  # @param format [ActionDispatch::Http::MimeNegotiation::Formatter] the response format
  # @return [void]
  def handle_failure(format)
    format.html { render :new, status: :unprocessable_entity }
    format.json { render json: @admin_stock.errors, status: :unprocessable_entity }
  end
end
