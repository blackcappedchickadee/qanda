namespace :qanda do
  #this task auto-generates corresponding document library folders in a Liferay instance (via web service calls).
  #YOU MUST remember to adjust the corresponding environment.rb values to reflect your given environment.
  #everything is placed inside the liferay2012monitoringfolderid (2012 Monitoring Folder in the Liferay DocLib).
  
  task :create_liferay_folders => :environment do
    #4 folders that will be created for each Project in each Grantee
    folder_data_quality_report = "Data Quality Report" #UDE Report goes in here
    folder_apr_from_hud = "APR Report from HUD"
    folder_monitoring_questionnaire = "Monitoring Questionnaire"
    folder_supporting_documentation = "Supporting Documentation"
    
    parent_folder_id = Rails.configuration.liferay2012monitoringfolderid #2012 Monitoring folder, contained in the Project Monitoring folder/hierarchy.
    
    company_id = Rails.configuration.liferaycompanyid #The default company id for the group. 
    group_id = Rails.configuration.liferaymcocgroupid #Maine CoC Group - in Liferay Group_ table.
    lr_folder_class_name = Rails.configuration.liferaywsdldlfoldername
    lr_mcoc_mon_cmte_roleid = Rails.configuration.liferaymcocmonitoringcmterole #The "Regular" role in Liferay for the Me CoC Monitoring Committee
    lr_mcoc_mon_cmte_role_actionids = Rails.configuration.liferaymcocmonitoringcmteroleactionids
    
    puts "Begin: Automatic folder creation"
  
    first_time = true
    
    work_grantee_name = ""
    
    liferay_grantee_folder_id = 0
    liferay_project_folder_id = 0
    
    @renewals_list = McocRenewals.find(:all, :order => 'grantee_name ASC, project_name ASC') 
    @renewals_list.each do |renewals|
    
      puts "Processing: mcoc_renewals. #{renewals.grantee_name} - Project name: #{renewals.project_name}..."
        if first_time
        puts "First time..."
        #Create the Grantee Folder
        grantee_name = renewals.grantee_name.tr(',.#@/!','') #sanitize grantee name, as Liferay will reject special chars when creating a new DocLib folder.
        grantee_desc = ""
        liferay_grantee_folder_id = LiferayFolder.new.add(group_id, parent_folder_id, grantee_name, grantee_desc)
        puts "Just created the grantee folder named #{grantee_name} with folder id of #{liferay_grantee_folder_id}"
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_grantee_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
        #next, we need to create Project Folder for this Grantee.
        project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
        project_desc = ""
        liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
        puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_project_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
        #and finally, we need to create the 4 folders in the newly-created project folder
        #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
        #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
        #DocLib folders for each.
        liferay_ude_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "")
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_ude_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
        
        liferay_apr_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "") 
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_apr_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
       
        liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_monitoring_pdf_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
        
        liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
        #apply permissions for the mcoc monitoring committee role
        LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_supporting_doc_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
       
        #in the mcoc_renewals model:
        #update the mcoc_renewals.hud_report_folder_id with the liferay_ude_report_folder_id,
        #and the mcoc_renewals.apr_report_folder_id with the liferay_apr_report_folder_id, 
        #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
        #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
        renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                  :project_folder_id => liferay_project_folder_id,
                  :hud_report_folder_id => liferay_ude_report_folder_id, 
                  :apr_report_folder_id => liferay_apr_report_folder_id,
                  :questionnaire_folder_id => liferay_monitoring_pdf_folder_id, 
                  :supporting_doc_folder_id => liferay_supporting_doc_folder_id)
        work_grantee_name = renewals.grantee_name
      else
        if work_grantee_name != renewals.grantee_name
          puts "work_grantee_name != renewals.grantee_name. Will need to create top-level folder"
          #Create the Grantee Folder
          grantee_name = renewals.grantee_name.tr(',.#@/!','') #sanitize grantee name, as Liferay will reject special chars when creating a new DocLib folder.
          grantee_desc = ""
          liferay_grantee_folder_id = LiferayFolder.new.add(group_id, parent_folder_id, grantee_name, grantee_desc)
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_grantee_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
          puts "Just created the grantee folder named #{grantee_name} with folder id of #{liferay_grantee_folder_id}"
          #next, we need to create Project Folder for this Grantee.
          project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
          project_desc = ""
          liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
          puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_project_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
          #and finally, we need to create the 4 folders in the newly-created project folder
          #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
          #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
          #DocLib folders for each.
          
          liferay_ude_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_ude_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_apr_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "") 
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_apr_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_monitoring_pdf_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_supporting_doc_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
          
          #update the mcoc_renewals.hud_report_folder_id with the liferay_ude_report_folder_id,
          #and the mcoc_renewals.apr_report_folder_id with the liferay_apr_report_folder_id, 
          #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
          #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
          renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                    :project_folder_id => liferay_project_folder_id,
                    :hud_report_folder_id => liferay_ude_report_folder_id, 
                    :apr_report_folder_id => liferay_apr_report_folder_id,
                    :questionnaire_folder_id => liferay_monitoring_pdf_folder_id, 
                    :supporting_doc_folder_id => liferay_supporting_doc_folder_id)
        else
          puts "work_grantee_name and renewals.grantee_name are the same"
          #next, we need to create Project Folder for this Grantee.
          project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
          project_desc = ""
          liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
          puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_project_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
          #we need to create the 4 folders in the newly-created project folder
          #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
          #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
          #DocLib folders for each.
          
          liferay_ude_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_ude_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_apr_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "") 
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_apr_report_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_monitoring_pdf_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)

          liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
          #apply permissions for the mcoc monitoring committee role
          LiferayPermission.new.add_for_mcoc_user(group_id, company_id, lr_folder_class_name, liferay_supporting_doc_folder_id, lr_mcoc_mon_cmte_roleid, lr_mcoc_mon_cmte_role_actionids)
          
          #update the mcoc_renewals.hud_report_folder_id with the liferay_ude_report_folder_id,
          #and the mcoc_renewals.apr_report_folder_id with the liferay_apr_report_folder_id, 
          #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
          #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
          renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                    :project_folder_id => liferay_project_folder_id,
                    :hud_report_folder_id => liferay_ude_report_folder_id, 
                    :apr_report_folder_id => liferay_apr_report_folder_id,
                    :questionnaire_folder_id => liferay_monitoring_pdf_folder_id, 
                    :supporting_doc_folder_id => liferay_supporting_doc_folder_id)
        end
      end

      work_grantee_name = renewals.grantee_name
      first_time = false
      
    end
    
    puts "End: Automatic folder creation"
    
  end
end