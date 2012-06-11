class CreateMcocAssets < ActiveRecord::Migration
  def change
    create_table :mcoc_assets do |t|
      t.integer :mcoc_renewals_id

      t.timestamps
    end
  end
end
