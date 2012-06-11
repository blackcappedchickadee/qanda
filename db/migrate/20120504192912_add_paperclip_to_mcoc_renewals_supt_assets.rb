class AddPaperclipToMcocRenewalsSuptAssets < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals_supporting_assets, :supporting_file_name, :string
    add_column :mcoc_renewals_supporting_assets, :supporting_content_type, :string
    add_column :mcoc_renewals_supporting_assets, :supporting_file_size, :integer
  end
end
