class AddDocNameToMcocAssets < ActiveRecord::Migration
  def change
    add_column :mcoc_assets, :doc_name, :string
  end
end
