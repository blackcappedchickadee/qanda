class McocAsset < ActiveRecord::Base
  
  attr_accessible :supporting_doc, :supporting_doc_file_name, :doc_name
  
  belongs_to :mcoc_renewals
  
  after_save :send_to_doclib
  
  has_attached_file :supporting_doc,
                :url => "/additional_documentation/:id/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/additional_documentation/:id/:basename.:extension"
  

      
  private
  
    def send_to_doclib
      tmp_filename = self.supporting_doc_file_name
      
      uploaded_file_desc = ""
      tmp_file = File.open(supporting_doc.to_file(:original), 'rb').read
      base64_uploaded_file = Base64.encode64(tmp_file)
      mcoc_group_id = Rails.configuration.liferaymcocgroupid.to_i
      supporting_doc_folder_id = session[:supporting_doc_folder_id].to_i
      
      liferay_ws = LiferayDocument.new
      
      #puts "mcoc_group_id}, #{supporting_doc_folder_id}, #{tmp_filename}, #{uploaded_file_desc} "
      
      added_result = liferay_ws.add(mcoc_group_id, supporting_doc_folder_id, tmp_filename, uploaded_file_desc, base64_uploaded_file)
      
      if (added_result=="notadded")
      else
         #apply permissions to the monitoring group role for additional assets that were added...
         added_doc_name = added_result[:doc_name]
         added_primary_key = added_result[:primary_key]
         
         liferay_ws_permission = LiferayPermission.new
         company_id = Rails.configuration.liferaycompanyid
         role_id = Rails.configuration.liferaymcocmonitoringcmterole
         name = Rails.configuration.liferaywsdldlfileentryname
         action_ids = Rails.configuration.liferaymcocmonitoringcmteroleactionidsfile
         liferay_ws_permission.add_for_mcoc_user(mcoc_group_id, company_id, name, added_primary_key, role_id, action_ids)
        
        
         #save the corresponding mcoc_asset row with the just-obtained doc_name above...
         self.update_column(:doc_name, added_doc_name)
      end
      
    end
  
  
end
