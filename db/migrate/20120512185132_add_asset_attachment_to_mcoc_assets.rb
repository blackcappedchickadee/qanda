class AddAssetAttachmentToMcocAssets < ActiveRecord::Migration
  def self.up
    add_column :mcoc_assets, :supporting_doc_file_name, :string
    add_column :mcoc_assets, :supporting_doc_content_type, :string
    add_column :mcoc_assets, :supporting_doc_file_size, :integer
    add_column :mcoc_assets, :supporting_doc_updated_at, :datetime
  end
  
  def self.down
    remove_column :mcoc_assets, :supporting_doc_file_name, :string
    remove_column :mcoc_assets, :supporting_doc_content_type, :string
    remove_column :mcoc_assets, :supporting_doc_file_size, :integer
    remove_column :mcoc_assets, :supporting_doc_updated_at, :datetime
  end
end
