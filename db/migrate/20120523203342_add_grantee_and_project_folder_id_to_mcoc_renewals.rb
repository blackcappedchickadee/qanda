class AddGranteeAndProjectFolderIdToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :grantee_folder_id, :integer
    add_column :mcoc_renewals, :project_folder_id, :integer
  end
end
