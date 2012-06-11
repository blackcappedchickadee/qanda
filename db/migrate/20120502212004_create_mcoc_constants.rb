class CreateMcocConstants < ActiveRecord::Migration
  def change
    create_table :mcoc_constants do |t|
      t.string :mcoc_constant_name
      t.string :mcoc_constant_value

      t.timestamps
    end
  end
end
