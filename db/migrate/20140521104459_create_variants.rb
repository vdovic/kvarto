class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :kimnatYa
      t.string :typYa
      t.string :mistoYa
      t.string :kimnatVin
      t.string :typVin
      t.string :mistoVin
      t.string :description

      t.timestamps
    end
  end
end
