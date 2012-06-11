Paperclip.interpolates :mcoc_renewals_id do |attachment, style|
  attachment.instance.mcoc_renewals.id
end

Paperclip.interpolates :mcoc_grantee_name do |attachment, style|
  attachment.instance.mcoc_renewals.grantee_name
end


Paperclip.interpolates :mcoc_project_name do |attachment, style|
  attachment.instance.mcoc_renewals.project_name
end



Paperclip.interpolates :grantee_name do |attachment, style|
  attachment.instance.grantee_name
end


Paperclip.interpolates :project_name do |attachment, style|
  attachment.instance.project_name
end
 
