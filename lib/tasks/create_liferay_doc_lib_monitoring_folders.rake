namespace :qanda do
  #this task auto-generates corresponding document library folders in a Liferay instance (via web service calls).
  #
  task :create_liferay_folders => :environment do
    #4 folders that will be created for each Project in each Grantee
    folder_apr_from_hud = "APR Report from HUD"
    folder_data_quality_report = "Data Quality Report"
    folder_monitoring_questionnaire = "Monitoring Questionnaire"
    folder_supporting_documentation = "Supporting Documentation"
    
    parent_folder_id = Rails.configuration.liferay2012monitoringfolderid #2012 Monitoring folder, contained in the Project Monitoring folder/hierarchy.
    
    group_id = Rails.configuration.liferaymcocgroupid #Maine CoC Group - in Liferay Group_ table.
    
    puts "Begin: Automatic folder creation"
  
    first_time = true
    
    work_grantee_name = ""
    
    liferay_grantee_folder_id = 0
    liferay_project_folder_id = 0
    
    McocRenewals.find_each do |renewals|
      
      puts "Processing: mcoc_renewals. #{renewals.grantee_name} - Project name: #{renewals.project_name}..."
      
      if first_time
        puts "First time..."
        #Create the Grantee Folder
        grantee_name = renewals.grantee_name.tr(',.#@/!','') #sanitize grantee name, as Liferay will reject special chars when creating a new DocLib folder.
        grantee_desc = ""
        liferay_grantee_folder_id = LiferayFolder.new.add(group_id, parent_folder_id, grantee_name, grantee_desc)
        puts "Just created the grantee folder named #{grantee_name} with folder id of #{liferay_grantee_folder_id}"
        #next, we need to create Project Folder for this Grantee.
        project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
        project_desc = ""
        liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
        puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
        #and finally, we need to create the 4 folders in the newly-created project folder
        #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
        #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
        #DocLib folders for each.
        liferay_hud_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "")
        LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "") #we're not concerned with fetching the id for this case
        liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
        liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
        #update the mcoc_renewals.hud_report_folder_id with the liferay_hud_report_folder_id,
        #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
        #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
        renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                  :project_folder_id => liferay_project_folder_id,
                  :hud_report_folder_id => liferay_hud_report_folder_id, 
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
          puts "Just created the grantee folder named #{grantee_name} with folder id of #{liferay_grantee_folder_id}"
          #next, we need to create Project Folder for this Grantee.
          project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
          project_desc = ""
          liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
          puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
          #and finally, we need to create the 4 folders in the newly-created project folder
          #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
          #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
          #DocLib folders for each.
          liferay_hud_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "")
          LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "") #we're not concerned with fetching the id for this case
          liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
          liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
          #update the mcoc_renewals.hud_report_folder_id with the liferay_hud_report_folder_id,
          #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
          #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
          renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                    :project_folder_id => liferay_project_folder_id,
                    :hud_report_folder_id => liferay_hud_report_folder_id, 
                    :questionnaire_folder_id => liferay_monitoring_pdf_folder_id, 
                    :supporting_doc_folder_id => liferay_supporting_doc_folder_id)
        else
          puts "work_grantee_name and renewals.grantee_name are the same"
          #next, we need to create Project Folder for this Grantee.
          project_name = renewals.project_name.tr(',.#@/!','') #sanitize project name, as Liferay will reject special chars when creating a new DocLib folder.
          project_desc = ""
          liferay_project_folder_id = LiferayFolder.new.add(group_id, liferay_grantee_folder_id, project_name, project_desc)
          puts "Just created the project folder named #{project_name} with folder id of #{liferay_project_folder_id}"
          #we need to create the 4 folders in the newly-created project folder
          #since we're going to "attach" the APR/UDE completeness Report from HUD, and the Supporting Documentation (inspection reports, etc.), and 
          #auto-attach the Monitoring Questionnaire (PDF) itself - we need to update the corresponding models once we've created the individual 
          #DocLib folders for each.
          liferay_hud_report_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_apr_from_hud, "")
          LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_data_quality_report, "") #we're not concerned with fetching the id for this case
          liferay_monitoring_pdf_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_monitoring_questionnaire, "")
          liferay_supporting_doc_folder_id = LiferayFolder.new.add(group_id, liferay_project_folder_id, folder_supporting_documentation, "")
          #update the mcoc_renewals.hud_report_folder_id with the liferay_hud_report_folder_id,
          #and the mcoc_renewals.questionnaire_folder_id with the liferay_monitoring_pdf_folder_id, 
          #and the mcoc_renewals.supporting_doc_folder_id with the liferay_supporting_doc_folder_id
          renewals.update_attributes(:grantee_folder_id => liferay_grantee_folder_id, 
                    :project_folder_id => liferay_project_folder_id,
                    :hud_report_folder_id => liferay_hud_report_folder_id, 
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