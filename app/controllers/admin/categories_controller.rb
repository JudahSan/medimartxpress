# frozen_string_literal: true

# Admin::CategoriesController manages the administrative actions related to categories.
# This includes displaying a list of categories, showing details for a specific category,
# creating new categories, updating existing categories, and deleting categories.
#
# Actions:
# - index: Lists all categories.
# - show: Displays details of a specific category.
# - new: Initializes a new category form.
# - edit: Prepares an existing category for editing.
# - create: Handles the creation of a new category.
# - update: Updates an existing category's attributes.
# - destroy: Deletes an existing category.
class Admin::CategoriesController < AdminController
  before_action :set_admin_category, only: %i[show edit update destroy]

  # GET /admin/categories or /admin/categories.json
  def index
    @admin_categories = Category.all
  end

  # GET /admin/categories/1 or /admin/categories/1.json
  def show; end

  # GET /admin/categories/new
  def new
    @admin_category = Category.new
  end

  # GET /admin/categories/1/edit
  def edit; end

  # POST /admin/categories or /admin/categories.json
  def create
    @admin_category = Category.new(admin_category_params)

    respond_to do |format|
      if @admin_category.save
        format.html do
          redirect_to admin_category_url(@admin_category),
                      notice: t("admin_categories.create.success")
        end
        format.json do
          render :show,
                 status:   :created,
                 location: @admin_category
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_entity
        end
        format.json do
          render json:   @admin_category.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /admin/categories/1 or /admin/categories/1.json
  def update
    respond_to do |format|
      if @admin_category.update(admin_category_params)
        format.html do
          redirect_to admin_category_url(@admin_category),
                      notice: t("admin_categories.update.success")
        end
        format.json do
          render :show,
                 status:   :ok,
                 location: @admin_category
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_entity
        end
        format.json do
          render json:   @admin_category.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/categories/1 or /admin/categories/1.json
  def destroy
    @admin_category.destroy!

    respond_to do |format|
      format.html do
        redirect_to admin_categories_url,
                    notice: t("admin_categories.destroy.success")
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_category
    @admin_category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_category_params
    params.require(:category).permit(:name,
                                     :description,
                                     :image)
  end
end
