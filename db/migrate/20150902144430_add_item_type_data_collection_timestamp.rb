class AddItemTypeDataCollectionTimestamp < ActiveRecord::Migration
  def change

    add_column :item_types, :marketDataLastCollected, :datetime

  end
end
