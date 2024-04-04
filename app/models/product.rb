class Product < ApplicationRecord
  # has_many_attached :images do |attachable|
  #   attachable.variant :thumb, resize_to_limit: [50, 50]
  # end
  belongs_to :category
  has_many :stocks
  has_many :order_products
  has_many_attached :images

  def images_as_thumbnail
    images.first.variant(resize_to_fill: [50, 50]).processed
  end
end
