class CreateAndSendPdfJob < Struct.new(:mcoc_renewal_id, :response_set_code, :response_html, :grantee_name, :project_name, :doc_name )
  
  require "prawn"
  
  def test_pdf
    Prawn::Document.generate("zzzzzz-hello.pdf") do
      #text "Hello World!"
      #first section - Agency Information
      font_size 16
      text "2012 Monitoring and Evaluation", :style => :bold 
      move_down 10
      font_size 14
      text "Agency Information", :style => :bold 
      font_size 10
      move_down 10
      text "Instructions:", :style => :bold 
      text "Please complete this form if your agency intends to apply for Renewal McKinney Vento Funding through the Maine Continuum of Care in 2012. If you do not intend to apply for renewal funding, please let us know. All forms and appropriate attachments must be received electronically by Scott Tibbitts no later than July 15, 2012. Please direct all questions to: stibbitts@mainehousing.org. A separate form must be completed for EACH program/project seeking renewal."
      move_down 10
      text "Agency Name", :style => :bold 
      text ":agency_name"
      move_down 5
      text "Program Name", :style => :bold 
      text ":program_name"
      move_down 5
      text "Project Address(es)", :style => :bold 
      text ":project_addresses"
      move_down 5
      text "Contact Person", :style => :bold 
      text ":contact_person"
      move_down 5
      text "Phone Number", :style => :bold 
      text ":contact_phone_number"
      move_down 5
      text "E-mail Address", :style => :bold 
      text ":contact_email_address"
      
      
      start_new_page
      font_size 14
      text "Program Information", :style => :bold 
      font_size 10
      move_down 10
      text "Please answer the following questions in regard to the program during the Operating Year covered by your most recently submitted HUD APR:"
      move_down 10
      text "1) Please provide a brief program summary. Include information about the type of program, population served, and the specific services or operations for which the McKinney-Vento funding was used."
      text ":program_summary"
      move_down 5
      text "2) Please describe how project participants have been assisted to access Mainstream resources, increase incomes and maximize their ability to live independently? (In your narrative, please make specific reference to relevant sections of your APR)."
      text ":program_self_suff"
      move_down 5
      text "3) Projects are required to verify homeless and chronic homeless status during intake. Please describe your verification process."
      text ":program_verify"
      move_down 5
      text "4) What percentage of your total budget for THIS program does the McKinney-Vento renewal represent?"
      text ":program_percentage"
      
      start_new_page
      font_size 14
      text "HMIS Participation", :style => :bold 
      font_size 10
      move_down 10
      text "Is your project participating in the Maine HMIS (Homeless Management Information System)?"
      text ":hmis_participation"
      move_down 10
      text ":hmis_ude_completeness_report_attached"
      move_down 10 
      text "What is your <b>UDE Data Completeness letter grade</b> for this project?", :inline_format => true
      text ":hmis_ude_grade"
      move_down 10
      text "What is your <b>DKR letter grade</b> for this project?", :inline_format => true
      text ":hmis_dkr_grade"
      
      start_new_page
      font_size 14
      text "Families or Youth", :style => :bold 
      font_size 10
      move_down 10
      text "Does your project work with Families or Youth?"
      text ":fam_participation"
      move_down 10
      text "Do you have a policy in place, staff assigned to inform clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form or process to document this?"
      text ":fam_policy_in_place"
      move_down 10
      text "Since you have indicated 'No or Not Applicable' to the prior question, please explain."
      text ":fam_no_policy"
      
      start_new_page
      font_size 14
      text "HUD Continuum Goals", :style => :bold 
      font_size 10
      move_down 10
      
      start_new_page
      font_size 14
      text "Physical Plant", :style => :bold 
      font_size 10
      move_down 10
      
      start_new_page
      font_size 14
      text "Finish", :style => :bold 
      font_size 10
      move_down 10
      
      
      
      pgnum_string = "Page <page> of <total>  :grantee_name - :project_name" 
      
      options = { :at => [bounds.right - 700, 0],
                    :width => 700,
                    :align => :right,
                    :size => 9,
                    :start_count_at => 1,
                    :color => "999999" }
      number_pages pgnum_string, options
      
      
    end
  end

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