class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  # GET /admin/products or /admin/products.json
  def index
    @admin_products = Product.all
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show
  end

  # GET /admin/products/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products or /admin/products.json
  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  # Updates a product's attributes, associates new images if provided, and ensures
  # existing images persist, redirecting on success or rendering the edit page on failure.
  def update
    # Find the product by its ID
    @admin_product = Product.find(params[:id])

    # Attempt to update the product with the provided parameters
    if @admin_product.update(admin_product_params.reject { |k| k["images"] })
      # If images are provided in the parameters, associate them with the product
      if admin_product_params["images"]
        admin_product_params["images"].each do |image|
          @admin_product.images.attach(image)
        end
      end
      # Redirect to the updated product page with a success notice
      redirect_to admin_products_path, notice: "Product updated successfully!"
    else
      # If update fails, render the edit page again with an error status
      render :edit, status: :unprocessable_entity
    end
  end


  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
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
end
