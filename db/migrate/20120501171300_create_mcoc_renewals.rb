class CreateMcocRenewals < ActiveRecord::Migration
  def change
    create_table :mcoc_renewals do |t|
      t.string :grantee_name
      t.string :project_name
      t.string :component

      t.timestamps
    end
  end
end
