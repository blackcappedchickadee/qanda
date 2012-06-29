class McocUserRenewal < ActiveRecord::Base
  
  attr_accessible :mcoc_renewals_id, :response_set_id
  
  belongs_to :mcoc_users
  
  has_many :mcoc_renewals
 
end
