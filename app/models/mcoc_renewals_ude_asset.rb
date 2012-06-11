class McocRenewalsUdeAsset < ActiveRecord::Base
  
  attr_accessible :ude_file_name, :ude_file_size
  
  belongs_to :mcoc_renewals
  
  has_attached_file :ude,
      :url => "/asset_ude/get/:id",  
      :path => ":Rails_root/asset_ude/:id/:basename.:extension"
  
  validates_attachment_size :ude, :less_than => 20.megabytes #todo -- pull this in from environment
  validates_attachment_presence :ude
  
  def file_name
    ude_file_name
  end 
  
  def file_size  
    ude_file_size  
  end
  
end
