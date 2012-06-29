Paperclip.interpolates :mcoc_renewal_id do |attachment, style|
  attachment.instance.mcoc_renewal.id
end

Paperclip.interpolates :mcoc_grantee_name do |attachment, style|
  #attachment.instance.mcoc_renewals.grantee_name
end


Paperclip.interpolates :mcoc_project_name do |attachment, style|
  #attachment.instance.mcoc_renewal.project_name
end



Paperclip.interpolates :grantee_name do |attachment, style|
  attachment.instance.grantee_name
end


Paperclip.interpolates :project_name do |attachment, style|
  attachment.instance.project_name
end
 
