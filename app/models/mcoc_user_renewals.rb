class McocUserRenewals < ActiveRecord::Base
  
  attr_accessible :mcoc_renewals_id
  
  belongs_to :mcoc_users
 
end
