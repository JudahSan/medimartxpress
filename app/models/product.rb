# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  price       :integer
#  category_id :bigint           not null
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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

  def images_as_category_section
    images.first.variant(resize_to_fill: [300, 300]).processed
  end

  # def images_as_cart_section
  #   images.first.variant(resize_to_fill: [300, 300]).processed
  # end
end
