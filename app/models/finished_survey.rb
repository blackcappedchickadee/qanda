class FinishedSurvey < ActiveRecord::Base
  
  attr_accessible :url, :grantee_name, :project_name, :user_id, :exec_dir_notified, :questionnaire, :questionnaire_file_name
  
  has_attached_file :questionnaire,
                :url => "/questionnaire/:grantee_name/:project_name/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/questionnaire/:grantee_name/:project_name/:basename.:extension"
  
end
