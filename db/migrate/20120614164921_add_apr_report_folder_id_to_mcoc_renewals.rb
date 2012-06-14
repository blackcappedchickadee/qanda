class AddAprReportFolderIdToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :apr_report_folder_id, :integer
  end
end
