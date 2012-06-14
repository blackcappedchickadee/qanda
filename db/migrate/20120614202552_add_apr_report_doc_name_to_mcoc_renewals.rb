class AddAprReportDocNameToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :apr_report_doc_name, :integer
  end
end
