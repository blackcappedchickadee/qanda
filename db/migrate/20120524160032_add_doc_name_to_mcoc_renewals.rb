class AddDocNameToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :doc_name, :string
  end
end
