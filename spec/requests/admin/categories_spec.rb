require 'rails_helper'

RSpec.describe "Admin::Categories", type: :request do
  let(:category) { create(:category) }
  let(:valid_attributes) { { name: 'New Category', description: 'Category Description', image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpeg'), 'image/jpeg') } }
  let(:invalid_attributes) { { name: ' ' } }
  before do
    @user = FactoryBot.create(:admin)
    sign_in @user
  end

  describe "GET /admin/categories" do
    it "returns a success response" do
      get admin_categories_path
      puts response.body
      puts response.status
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/categories/:id" do
    it "returns a success response" do
      get admin_categories_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/categories/new" do
    it "returns a success response" do
      get new_admin_category_path
      expect(response).to have_http_status(:ok)
    end
  end

end