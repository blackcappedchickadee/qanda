require 'mustache'

class MustacheContext < ::Mustache
  
  attr_reader :recipient_email_address, :recipient_name, :deadline_date
  
  def initialize(recipient_email_address, recipient_name, deadline_date)
    @recipient_email_address = recipient_email_address
    @recipient_name = recipient_name
    @deadline_date = deadline_date
  end
  
  
end