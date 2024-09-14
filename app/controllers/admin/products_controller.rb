# frozen_string_literal: true

# Manages stock levels for products within the admin dashboard.
class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[show edit update destroy]

  # GET /admin/products or /admin/products.json
  def index
    @pagy, @admin_products = pagy(Product.all)
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show; end

  # GET /admin/products/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/products/1/edit
  def edit; end

  # POST /admin/products or /admin/products.json
  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html do
          redirect_to admin_product_url(@admin_product),
                      notice: t("product_controller.create.success")
        end
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  # Updates a product's attributes and handles image attachments.
  def update
    if @admin_product.update(product_update_params)
      attach_images if admin_product_params["images"].present?
      redirect_to admin_product_url(@admin_product), notice: t("product_controller.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html do
        redirect_to admin_products_url, notice: t("product_controller.destroy.success")
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_product
    @admin_product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
  end

  # Filtered parameters for update action.
  def product_update_params
    admin_product_params.except(:images)
  end

  # Attach images to the product.
  def attach_images
    admin_product_params["images"].each do |image|
      @admin_product.images.attach(image)
    end
  end
end
