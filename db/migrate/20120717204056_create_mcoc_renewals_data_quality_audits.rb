class CreateMcocRenewalsDataQualityAudits < ActiveRecord::Migration
  def change
    create_table :mcoc_renewals_data_quality_audits do |t|
      t.integer :user_id
      t.integer :mcoc_renewal_id
      t.integer :section_id
      t.string :audit_key
      t.string :audit_value

      t.timestamps
    end
  end
end
