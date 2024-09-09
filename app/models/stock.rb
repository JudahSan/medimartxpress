# == Schema Information
#
# Table name: stocks
#
#  id         :bigint           not null, primary key
#  product_id :bigint           not null
#  amount     :integer
#  size       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Stock < ApplicationRecord
  belongs_to :product
end
