class FinishedSurveyMailer < ActionMailer::Base
  default from: ENV['GMAIL_USER_NAME']
  
  def send_finished_email(finished_survey)

      @finished_survey = finished_survey
      
      mail(:to => ENV['GMAIL_USER_NAME'],
           :subject => "2012 Monitoring Questionnaire notification - #{@finished_survey.grantee_name} - #{@finished_survey.project_name}",
           :from => ENV['GMAIL_USER_NAME'])
  end
  
end