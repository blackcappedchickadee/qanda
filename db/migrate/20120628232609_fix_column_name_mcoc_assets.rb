class FixColumnNameMcocAssets < ActiveRecord::Migration
  def change
    rename_column :mcoc_assets, :mcoc_renewals_id, :mcoc_renewal_id
  end
end
