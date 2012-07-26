class McocRenewalsDataQualityAudit < ActiveRecord::Base
  
  attr_accessible :user_id, :mcoc_renewal_id, :section_id, :audit_key, :audit_value , :section_name
  
end
