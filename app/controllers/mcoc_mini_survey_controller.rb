class McocMiniSurveyController < ApplicationController  
    
  def index  
    if user_signed_in?  
      @mcoc_mini_survey = session[:mcoc_mini_survey]
      @tmp_user_id = session[:user_id]
      @tmp_mcoc_renewal_id = session[:mcoc_renewal_id]
      
      @constant_orgname = McocConstants.where(:mcoc_constant_name => 'mini_survey_orgname')
      @mini_survey_orgname = @constant_orgname.first.mcoc_constant_value
      
    end
  end
  
  def handle_mini_survey_pref
    @mcoc_mini_survey = session[:mcoc_mini_survey]
    @tmp_user_id = session[:user_id]
    @tmp_mcoc_renewal_id = session[:mcoc_renewal_id]
    
    if params[:mini_survey_pref] == "Yes"
      #instance a mini satisfaction survey 
      mini_survey_access_code = Rails.configuration.minisatisfactionsurveyaccesscode
      survey = Survey.find_by_access_code(mini_survey_access_code)
      response_set = ResponseSet.create(:survey => survey, :user_id => @tmp_user_id)
      @mcoc_mini_survey.update_attributes(:response_set_access_code => response_set.access_code, :mcoc_renewal_id => @tmp_mcoc_renewal_id , :dont_ask => true)
      session[:response_set_code] = response_set.access_code
      redirect_to edit_my_survey_path(:survey_code => survey.access_code, :response_set_code => response_set.access_code), :action => :edit
    else
      #update the dont_ask column so we won't bother the user again
      @mcoc_mini_survey.update_attributes(:dont_ask => true)
      redirect_to list_surveys_path, :action => :list_current
    end

  end
  
  
end