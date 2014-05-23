class AddUserIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :user_id, :integer
    add_index :variants, :user_id
  end
end
