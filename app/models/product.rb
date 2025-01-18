# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  description :text
#  name        :string
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Product < ApplicationRecord
  # has_many_attached :images do |attachable|
  #   attachable.variant :thumb, resize_to_limit: [50, 50]
  # end

  # Validation
  validates :name, presence: true

  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many :order_products, dependent: :nullify
  has_many_attached :images
  has_rich_text :description

  def images_as_thumbnail
    images.first.variant(resize_to_fill: [50, 50]).processed
  end

  def images_as_category_section
    images.first.variant(resize_to_fill: [300, 300]).processed
  end

  # def images_as_cart_section
  #   images.first.variant(resize_to_fill: [300, 300]).processed
  # end
end
