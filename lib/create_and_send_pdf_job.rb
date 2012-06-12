class CreateAndSendPdfJob < Struct.new(:mcoc_renewal_id, :response_set_code, :response_html, :grantee_name, :project_name, :doc_name )
  

  def create_and_put_pdf

    @mcoc_renewal = McocRenewals.find(mcoc_renewal_id)

    @response_set = ResponseSet.find_by_access_code(response_set_code, :include => {:responses => [:question, :answer]})
    if @response_set
      @survey = @response_set.survey
      #html = render_to_string(:layout => false , :action => "show")
      html = response_html
      pdf_file = PDFKit.new(html).to_pdf
      pdf_file_as_base_64 = Base64.encode64(pdf_file)

      #to do: wire in a please wait dialog, or fire this off asynchronously (longer-running process that doesn't need
      #to hang up the user)
      mcoc_group_id = Rails.configuration.liferaymcocgroupid.to_i
      mcoc_questionnaire_file_name_stem = Rails.configuration.questionnairefilename
      pdf_file_name = "#{@mcoc_renewal.project_name}-#{mcoc_questionnaire_file_name_stem}"
      description = ""
      mcoc_folder_id = @mcoc_renewal.questionnaire_folder_id

      liferay_ws = LiferayDocument.new
      #So we have the most up to date questionnaire pushed to the DocLib) we will first see if we
      #already have a DocLib entry:
      
      liferay_ws_result = liferay_ws.get(mcoc_group_id, mcoc_folder_id, doc_name)
      
      if liferay_ws_result == "found"
        #we need to update, as opposed to add
        liferay_ws.update(mcoc_group_id, mcoc_folder_id, doc_name, pdf_file_name, description, pdf_file_as_base_64)
      else
        #we didn't find an existing DocLib entry, so we'll create a new one via an "add" call:
        added_result = liferay_ws.add(mcoc_group_id, mcoc_folder_id, pdf_file_name, description, pdf_file_as_base_64)
        
        #update the given mcoc_renewal record with the doc_name that we just generated due to the addition of the document in the doclib.
        questionnaire_doc_name = added_result[:doc_name]
        @mcoc_renewal.update_column(:questionnaire_doc_name, questionnaire_doc_name)
        
        #call the webservice that applies specific permissions on the file (primary_ley) just added to the document library:
        liferay_ws_permission = LiferayPermission.new
        company_id = Rails.configuration.liferaycompanyid
        added_primary_key = added_result[:primary_key]
        role_id = Rails.configuration.liferaymcocmonitoringcmterole
        name = Rails.configuration.liferaywsdldlfileentryname
        action_ids = Rails.configuration.liferaymcocmonitoringcmteroleactionidsfile
        liferay_ws_permission.add_for_mcoc_user(mcoc_group_id, company_id, name, added_primary_key, role_id, action_ids)
        
      end

      url_stem = Rails.configuration.doclibrootstem 
      url_path = Rails.configuration.doclibrootmainecoc
      full_doclib_url = "#{url_stem}#{url_path}#{mcoc_folder_id}"

      @finished_survey = FinishedSurvey.create({:url => full_doclib_url, :grantee_name => grantee_name, :project_name => project_name})

      #send an email notification
      FinishedSurveyMailer.delay.send_finished_email(@finished_survey) #was FinishedSurveyMailer.send_finished_email.deliver

    end
    
  end
  handle_asynchronously :create_and_put_pdf, :queue => 'completedsurveys'
  
  
  
end