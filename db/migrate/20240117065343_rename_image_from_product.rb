class RenameImageFromProduct < ActiveRecord::Migration[7.1]
  def up
    change_column :products, :image, :attachment
  end

  def down
    # If you need to rollback, define how to reverse the change here
    change_column :products, :image, :string
  end
end
