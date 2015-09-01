class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|

      t.string :name
      t.text :description

      t.integer :iconID
      t.integer :volume

      t.timestamps null: false
    end
  end
end
