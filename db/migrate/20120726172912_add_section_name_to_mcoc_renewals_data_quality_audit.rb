class AddSectionNameToMcocRenewalsDataQualityAudit < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals_data_quality_audits, :section_name, :string
  end
end
