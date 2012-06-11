class AddFolderIdsToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :hud_report_folder_id, :integer
    add_column :mcoc_renewals, :questionnaire_folder_id, :integer
    add_column :mcoc_renewals, :supporting_doc_folder_id, :integer
  end
end
