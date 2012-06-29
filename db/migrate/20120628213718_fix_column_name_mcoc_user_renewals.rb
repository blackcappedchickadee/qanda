class FixColumnNameMcocUserRenewals < ActiveRecord::Migration
  def change
    rename_column :mcoc_user_renewals, :mcoc_renewals_id, :mcoc_renewal_id
  end
end
