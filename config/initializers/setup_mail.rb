ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "gmail.com",  
  :user_name            => ENV['GMAIL_USER_NAME'],
  :password             => ENV['GMAIL_USER_PASS'],
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}
