
namespace :qanda do
  #this task is a very simple one that instances 9 survey sessions for ext user id 10404
  task :init_10404 => :environment do
    survey_access_code = "2012-monitoring-and-evaluation"
    puts "Instancing survey #{survey_access_code}..."
  
    ext_user_id = 10404
    user_renewals = [21,22,23,24,25,26,27,28,29]
    user_session = McocExtappSessions.where(:external_user_id => ext_user_id, :is_active => true)
    puts "located user_session = #{user_session.first.external_user_id}"
    survey = Survey.find_by_access_code(survey_access_code)
  
    puts "Located Survey #{survey.id}"
      
    user_renewals.each do |i|
    
      puts "Creating instanced response set and relating to user #{ext_user_id} via mcoc_user_renewals..."
      
      user_renewals = McocUserRenewals.where(:mcoc_renewals_id => i)
      puts "obtained mcoc_user_renewals id #{user_renewals.first.id}"
      
      response_set = ResponseSet.create(:survey => survey, :user_id => 1 )
      puts "Instanced new response set. Access code is #{response_set.access_code}"
      
      user_renewals.first.update_attribute(:response_set_id, response_set.id)
      
      puts "updated  mcoc_user_renewals id #{user_renewals.first.id} with response_set_id = #{response_set.id}"
    
    end
    
  end
  
  #this task is a very simple one that instances 9 survey sessions for ext user id 10404
  task :init_10404_a => :environment do
    survey_access_code = "2012-monitoring-and-evaluation"
    puts "Instancing survey #{survey_access_code}..."
  
    ext_user_id = 10404
    user_renewals = [4,5,6,37] #dev env ids
    user_session = McocExtappSessions.where(:external_user_id => ext_user_id, :is_active => true)
    puts "located user_session = #{user_session.first.external_user_id}"
    survey = Survey.find_by_access_code(survey_access_code)
  
    puts "Located Survey #{survey.id}"
      
    user_renewals.each do |i|
    
      puts "Creating instanced response set and relating to user #{ext_user_id} via mcoc_user_renewals..."
      
      user_renewals = McocUserRenewals.where(:mcoc_renewals_id => i)
      puts "obtained mcoc_user_renewals id #{user_renewals.first.id}"
      
      response_set = ResponseSet.create(:survey => survey, :user_id => 1 )
      puts "Instanced new response set. Access code is #{response_set.access_code}"
      
      user_renewals.first.update_attribute(:response_set_id, response_set.id)
      
      puts "updated  mcoc_user_renewals id #{user_renewals.first.id} with response_set_id = #{response_set.id}"
    
    end
    
  end
  
  
  
end