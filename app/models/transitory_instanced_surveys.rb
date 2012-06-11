class TransitoryInstancedSurveys 
  
  attr_accessor :survey_access_code, :response_access_code, :grantee_name, :project_name
 
  def initialize(survey_access_code, response_access_code, grantee_name, project_name)
    @survey_access_code = survey_access_code
    @response_access_code = response_access_code
    @grantee_name = grantee_name
    @project_name = project_name
  end

end