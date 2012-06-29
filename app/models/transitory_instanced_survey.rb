class TransitoryInstancedSurvey
  
  attr_accessor :survey_access_code, :response_access_code, :grantee_name, :project_name, :completed_flag, :completed_date
 
  def initialize(survey_access_code, response_access_code, grantee_name, project_name, completed_flag, completed_date)
    @survey_access_code = survey_access_code
    @response_access_code = response_access_code
    @grantee_name = grantee_name
    @project_name = project_name
    @completed_flag = completed_flag
    @completed_date = completed_date
  end

end