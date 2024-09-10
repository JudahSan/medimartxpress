# frozen_string_literal: true

# == Schema Information
#
# Table name: stocks
#
#  id         :bigint           not null, primary key
#  amount     :integer
#  size       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_stocks_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Stock < ApplicationRecord
  belongs_to :product
end
