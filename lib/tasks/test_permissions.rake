namespace :qanda do
  task :test_permissions => :environment do
    puts "begin..."
    
    liferay_ws_permission = LiferayPermission.new
    #group_id, company_id, name, prim_key, role_id, action_ids
    group_id = Rails.configuration.liferaymcocgroupid
    company_id = Rails.configuration.liferaycompanyid
    name = Rails.configuration.liferaywsdldlfoldername
    prim_key = '16031'  #DLFolder.folderId
    role_id = '17479'
    action_ids = Rails.configuration.liferaymcocmonitoringcmteroleactionids
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    
    puts "finished, with status of #{retval}..."
    
    #Qanda::Application.config.liferaywsdldlfoldername = 'com.liferay.portlet.documentlibrary.model.DLFolder'
    #Qanda::Application.config.liferaywsdldlfileentryname ='com.liferay.portlet.documentlibrary.model.DLFileEntry'
    
    #16144 - me dhhs
    prim_key = '16144'  #folder.getPrimaryKey() or fileEntry.getPrimaryKey() //DLFolder.folderId - DLFileEntry.fileEntryId
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    puts "finished, with status of #{retval}..."
    
    #16145 selter care plus 1 penobscot
    prim_key = '16145'  #folder.getPrimaryKey() or fileEntry.getPrimaryKey() //DLFolder.folderId - DLFileEntry.fileEntryId
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    puts "finished, with status of #{retval}..."
    
    #16146 - apr report from hud folder
    prim_key = '16146'  #folder.getPrimaryKey() or fileEntry.getPrimaryKey() //DLFolder.folderId - DLFileEntry.fileEntryId
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    puts "finished, with status of #{retval}..."
    
    #16146 - monit questionnaire folder
    prim_key = '16148'  #folder.getPrimaryKey() or fileEntry.getPrimaryKey() //DLFolder.folderId - DLFileEntry.fileEntryId
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    puts "finished, with status of #{retval}..."
    
    #now, test applying permissions to a specific file in the doclib folder to the same group/roleid
    name = Rails.configuration.liferaywsdldlfileentryname
    action_ids = Rails.configuration.liferaymcocmonitoringcmteroleactionidsfile
    prim_key = '17448' #DLFileEntry.fileEntryId - NOT doc_name...
    retval = liferay_ws_permission.add_for_mcoc_user(group_id, company_id, name, prim_key, role_id, action_ids)
    puts "finished, with status of #{retval}..."
    
    
  end
end


