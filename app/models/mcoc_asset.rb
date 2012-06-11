class McocAsset < ActiveRecord::Base
  
  attr_accessible :supporting_doc, :supporting_doc_file_name, :doc_name
  
  belongs_to :mcoc_renewals
  
  after_save :send_to_doclib
  
  has_attached_file :supporting_doc,
                :url => "/additional_documentation/:mcoc_grantee_name/:mcoc_project_name/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/additional_documentation/:mcoc_grantee_name/:mcoc_project_name/:basename.:extension"
  

      
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

      added_doc_name = liferay_ws.add(mcoc_group_id, supporting_doc_folder_id, tmp_filename, uploaded_file_desc, base64_uploaded_file)
      puts "after adding to LR doclib = #{added_doc_name}"
      
      if (added_doc_name=="notadded")
      else
         self.update_column(:doc_name, added_doc_name)
      end
      
    end
  
  
end
