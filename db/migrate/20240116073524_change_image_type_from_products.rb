class ChangeImageTypeFromProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :image , :attachment
  end
end
