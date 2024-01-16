class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.decimal :old_price
      t.string :short_description
      t.text :full_description
      t.string :image

      t.timestamps
    end
  end
end
