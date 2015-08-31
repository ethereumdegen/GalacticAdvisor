class CreateCrestData < ActiveRecord::Migration
  def change
    create_table :crest_data do |t|

      t.timestamps null: false
    end
  end
end
