class CreateRegionalItemPriceData < ActiveRecord::Migration
  def change
    create_table :regional_item_price_data do |t|

 
      t.integer :itemID
      t.integer :regionID

      t.integer :volume
      t.integer :avgPrice
      t.integer :lowPrice
      t.integer :highPrice
      t.integer :orderCount
      t.datetime :marketDate

      t.timestamps null: false
    end
  end
end
