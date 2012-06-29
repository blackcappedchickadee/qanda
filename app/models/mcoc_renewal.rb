class McocRenewal < ActiveRecord::Base
  
  has_many :mcoc_assets
  has_many :mcoc_user_renewals
  
  attr_accessible :grantee_name, :project_name, :component, :attachment_ude, :mcoc_assets_attributes, 
                  :grantee_folder_id, :project_folder_id, 
                  :hud_report_folder_id, :questionnaire_folder_id,:supporting_doc_folder_id, :doc_name, :questionnaire_doc_name,
                  :attachment_apr, :apr_report_folder_id, :apr_report_doc_name
  
  accepts_nested_attributes_for :mcoc_assets, :allow_destroy => true
  
  has_attached_file :attachment_ude,
                :url => "/ude_report/:grantee_name/:project_name/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/ude_report/:grantee_name/:project_name/:basename.:extension"
 
  has_attached_file :attachment_apr,
                :url => "/apr_report/:grantee_name/:project_name/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/apr_report/:grantee_name/:project_name/:basename.:extension"
 

end


