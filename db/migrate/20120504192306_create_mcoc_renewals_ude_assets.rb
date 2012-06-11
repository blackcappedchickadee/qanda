class CreateMcocRenewalsUdeAssets < ActiveRecord::Migration
  def change
    create_table :mcoc_renewals_ude_assets do |t|
      t.integer :renewals_id
      t.string :asset_name

      t.timestamps
    end
  end
end
