class AddPaperclipToMcocRenewals < ActiveRecord::Migration

  def self.up
  add_column :mcoc_renewals, :attachment_apr_file_name, :string
  add_column :mcoc_renewals, :attachment_apr_content_type, :string
  add_column :mcoc_renewals, :attachment_apr_file_size, :integer
  add_column :mcoc_renewals, :attachment_apr_updated_at, :datetime
  end

  def self.down
  remove_column :mcoc_renewals, :attachment_apr_file_size
  remove_column :mcoc_renewals, :attachment_apr_content_type
  remove_column :mcoc_renewals, :attachment_apr_file_name
  remove_column :mcoc_renewals, :attachment_apr_updated_at
  end
  
  
end
