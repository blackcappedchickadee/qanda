class HomeController < ApplicationController  
    
  def index  
     if user_signed_in?  

        @users = User.all
        
        @survey_id = 55
        @response_set = ResponseSet.find_by_survey_id_and_user_id(@survey_id, current_user.id) 
        
        @survey = Survey.find_by_id(@survey_id)

 
      end
  end
  
  
end