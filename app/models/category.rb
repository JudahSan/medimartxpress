# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  # has_one_attached :image do |attachable|
  #   attachable.variant :thumb, resize_to_limit: [50,50] # reduce image thumbnail size to 50x50
  # end

  has_one_attached :image
  # def thumbnail
  #   if image.attached?
  #     image.variant(resize_to_limit: [50, 50])
  #   else
  #     "https://via.placeholder.com/50"
  #   end
  # end

  has_many :products
  def image_as_thumbnail
    image.variant(resize_to_limit: [50, 50]).processed
  end
end
