class CreateAdminStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :amount
      t.string :size

      t.timestamps
    end
  end
end
