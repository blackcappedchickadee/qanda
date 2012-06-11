class AddPaperclipToMcocRenewalsUde < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals_ude_assets, :ude_file_name, :string
    add_column :mcoc_renewals_ude_assets, :ude_content_type, :string
    add_column :mcoc_renewals_ude_assets, :ude_file_size, :integer
  end
end
