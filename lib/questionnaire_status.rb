class QuestionnaireStatus
  
  include Questionnaire::Data
  
  def initialize(user_id, mcoc_renewal_id, response_set_code, grantee_name, project_name, section_id)
      
      @user_id = user_id
      @mcoc_renewal_id = mcoc_renewal_id
      @response_set_code = response_set_code
      @grantee_name = grantee_name
      @project_name = project_name

      response_set = ResponseSet.find_by_access_code(response_set_code)
      @response_set_id = response_set.id
      @survey_id = response_set.survey_id
      
      configure(user_id, mcoc_renewal_id, response_set_code, grantee_name, project_name, "")
      
      case section_id.to_s
        when "0"
          get_agency_information_section_values
          get_program_information_section_values
          get_hmis_information_section_values
          get_families_youth_section_values
          get_hud_section_values
          get_physical_plant_section_values
          final_section_values

        when "1"
          get_agency_information_section_values
        when "2" 
          get_program_information_section_values
        when "3"
          get_hmis_information_section_values
        when "4"
          get_families_youth_section_values
        when "5"
          get_hud_section_values
        when "6"
          get_physical_plant_section_values
        when "7"
          final_section_values
      end

  end #initialize
end