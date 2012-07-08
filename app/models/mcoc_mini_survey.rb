class McocMiniSurvey < ActiveRecord::Base
  
  attr_accessible :mcoc_renewal_id, :dont_ask, :response_set_access_code, :user_id, :mcoc_renewal_id, :mini_survey, :mini_survey_file_name
  
  has_attached_file :mini_survey,
                :url => "/mini_survey/:grantee_name/:project_name/:basename.:extension",    
                :path => ":rails_root/2012_Renewals_Assets/mini_survey/:grantee_name/:project_name/:basename.:extension"
  
end
