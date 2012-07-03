class CreateAndSendPdfJob
  
  require "prawn"
  
  def test_pdf(mcoc_renewal_id, response_set_code, response_html, grantee_name, project_name, doc_name)
    
    not_provided_text = "<b><color rgb='ff0000'>Not Provided</color></b>"
    
    @grantee_name = grantee_name
    @project_name = project_name
    response_set = ResponseSet.find_by_access_code(response_set_code)
    response_set_id = response_set.id
    survey_id = response_set.survey_id
    
    survey_section_agency_information = SurveySection.find_by_data_export_identifier_and_survey_id("agency_information", survey_id)
    survey_section_program_information = SurveySection.find_by_data_export_identifier_and_survey_id("program_information", survey_id)
    survey_section_hmis_information = SurveySection.find_by_data_export_identifier_and_survey_id("hmis_participation", survey_id)
    survey_section_families_youth = SurveySection.find_by_data_export_identifier_and_survey_id("families_youth", survey_id)
    survey_section_hud_continuum_goals = SurveySection.find_by_data_export_identifier_and_survey_id("hud_continuum_goals", survey_id)
    survey_section_physical_plant = SurveySection.find_by_data_export_identifier_and_survey_id("physical_plant", survey_id)
    survey_section_finish = SurveySection.find_by_data_export_identifier_and_survey_id("finish", survey_id)
 
    #page 1 values 
    agency_name = get_agency_information_response("agency_name", response_set_id, survey_section_agency_information)
    program_name = get_agency_information_response("program_name", response_set_id, survey_section_agency_information)
    project_address = get_agency_information_response("project_address", response_set_id, survey_section_agency_information)
    contact_person = get_agency_information_response("contact_person", response_set_id, survey_section_agency_information)
    phone_number = get_agency_information_response("phone_number", response_set_id, survey_section_agency_information)
    e_mail_address = get_agency_information_response("e_mail_address", response_set_id, survey_section_agency_information)
    
    #page 2 values
    data_program_info = get_response_with_only_one_value("data_program_info", response_set_id, survey_section_program_information)
    self_suff = get_response_with_only_one_value("self_suff", response_set_id, survey_section_program_information)
    program_verif_proc = get_response_with_only_one_value("program_verif_proc", response_set_id, survey_section_program_information)
    program_renewal_budget_pct = get_response_with_only_one_value("program_renewal_budget_pct", response_set_id, survey_section_program_information)
    
    #page 3 values
    participating_maine_hmis = get_response_with_only_one_value("your_project_participating_maine_hmis", response_set_id, survey_section_hmis_information)
    attachment_info_ude = get_attachment_info_ude(mcoc_renewal_id)
    letter_grade_ude = get_response_with_only_one_value("letter_grade_ude", response_set_id, survey_section_hmis_information)
    letter_grade_dkr = get_response_with_only_one_value("letter_grade_dkr", response_set_id, survey_section_hmis_information)
    
    #page 4 values
    project_work_with_families_youth = get_response_with_only_one_value("project_work_with_families_youth", response_set_id, survey_section_families_youth)
    and_form_process_document_this = get_response_with_only_one_value("and_form_process_document_this", response_set_id, survey_section_families_youth)
    applicable_prior_question_please_explain = get_response_with_only_one_value("applicable_prior_question_please_explain", response_set_id, survey_section_families_youth)
    
    #page 5 values
    attachment_info_apr = get_attachment_info_apr(mcoc_renewal_id)
    reported_your_most_recent_apr = get_response_with_only_one_value("reported_your_most_recent_apr", response_set_id, survey_section_hud_continuum_goals)
    if_below_85_please_explain = get_response_with_only_one_value("if_below_85_please_explain", response_set_id, survey_section_hud_continuum_goals)
    employed_at_program_at_exit = get_response_with_only_one_value("employed_at_program_at_exit", response_set_id, survey_section_hud_continuum_goals)
    less_than_20_please_explain = get_response_with_only_one_value("less_than_20_please_explain", response_set_id, survey_section_hud_continuum_goals)
    project_involve_transitional_housing_projects = get_response_with_only_one_value("project_involve_transitional_housing_projects", response_set_id, survey_section_hud_continuum_goals)
    moved_from_transitional_permanent_housing = get_response_with_only_one_value("moved_from_transitional_permanent_housing", response_set_id, survey_section_hud_continuum_goals)
    if_below_65_please_explain = get_response_with_only_one_value("if_below_65_please_explain", response_set_id, survey_section_hud_continuum_goals)
    involve_permanent_supportive_housing_projects = get_response_with_only_one_value("involve_permanent_supportive_housing_projects", response_set_id, survey_section_hud_continuum_goals)    
    permanent_housing_over_6_months = get_response_with_only_one_value("permanent_housing_over_6_months", response_set_id, survey_section_hud_continuum_goals)    
    if_below_77_please_explain = get_response_with_only_one_value("if_below_77_please_explain", response_set_id, survey_section_hud_continuum_goals)    


    myDoc = Prawn::Document.generate("zzzzzz-hello.pdf") do
      
      #text "Hello World!"
      #first section - Agency Information
      font_size 16
      text "2012 Monitoring and Evaluation", :style => :bold 
      move_down 10
      font_size 14
      text "Grantee Name:", :style => :bold
      move_down 5
      text "#{grantee_name}"
      move_down 10
      text "Project Name:", :style => :bold
      move_down 5
      text "#{project_name}"
      move_down 5
      font_size 12
      stroke_horizontal_rule
      move_down 15
      text "Agency Information", :style => :bold 
      font_size 10
      move_down 10
      text "Instructions:", :style => :bold 
      text "Please complete this form if your agency intends to apply for Renewal McKinney Vento Funding through the Maine Continuum of Care in 2012. If you do not intend to apply for renewal funding, please let us know. All forms and appropriate attachments must be received electronically by Scott Tibbitts no later than July 15, 2012. Please direct all questions to: stibbitts@mainehousing.org. A separate form must be completed for EACH program/project seeking renewal."
      move_down 10
      text "Agency Name", :style => :bold 
      if agency_name.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{agency_name}"
      end
      move_down 5
      text "Program Name", :style => :bold 
      if program_name.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{program_name}"
      end
      move_down 5
      text "Project Address(es)", :style => :bold 
      if project_address.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{project_address}"
      end
      move_down 5
      text "Contact Person", :style => :bold 
      if contact_person.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{contact_person}"
      end
      move_down 5
      text "Phone Number", :style => :bold 
      if phone_number.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{phone_number}"
      end
      move_down 5
      text "E-mail Address", :style => :bold 
      if e_mail_address.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{e_mail_address}"
      end 
      
      start_new_page
      font_size 14
      text "Program Information", :style => :bold 
      font_size 10
      move_down 10
      text "Please answer the following questions in regard to the program during the Operating Year covered by your most recently submitted HUD APR:"
      move_down 10
      text "1) Please provide a brief program summary. Include information about the type of program, population served, and the specific services or operations for which the McKinney-Vento funding was used."
      move_down 5
      if data_program_info.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{data_program_info}"
      end
      move_down 10
      text "2) Please describe how project participants have been assisted to access Mainstream resources, increase incomes and maximize their ability to live independently? (In your narrative, please make specific reference to relevant sections of your APR)."
      move_down 5
      if self_suff.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{self_suff}"
      end
      move_down 10
      text "3) Projects are required to verify homeless and chronic homeless status during intake. Please describe your verification process."
      move_down 5
      if program_verif_proc.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{program_verif_proc}"
      end
      move_down 10
      text "4) What percentage of your total budget for THIS program does the McKinney-Vento renewal represent?"
      if program_renewal_budget_pct.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "#{program_renewal_budget_pct}"
      end
      
      
      start_new_page
      font_size 14
      text "HMIS Participation", :style => :bold 
      font_size 10
      move_down 10
      text "Is your project participating in the Maine HMIS (Homeless Management Information System)?"
      move_down 5
      var_hmis_particp = ""
      puts " participating_maine_hmis = #{participating_maine_hmis}"
      if participating_maine_hmis.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_hmis_particp = participating_maine_hmis
        text "#{var_hmis_particp}"
      end
      if var_hmis_particp == "Yes"
        move_down 10
        text "Please follow this link to a video that will explain how to run the 'UDE Data Completeness Report', and how to make any corrections or updates needed to improve your data completeness."
        move_down 5
        formatted_text [{:text =>"CoC UDE Data Completeness and DKR Reports Video",
                         :color => "0000FF",
                         :link =>"http://mainehmis.org/2011/12/07/coc-ude-data-completeness-and-dkr-reports-video/"}]
        move_down 5
        text "Run the report for this facility (which is up for renewal this year) <b><u>and attach an electronic copy of the report below. Please run the UDE Data Completeness Report for the same time frame as your most recent APR Operating Year for each program.</u></b>", :inline_format => true
        move_down 10
        if attachment_info_ude.nil?
           text "#{not_provided_text}", :inline_format => true
        else
          text "UDE Data Completeness Report attached: #{attachment_info_ude}"
        end
        move_down 10 
        text "What is your <b>UDE Data Completeness letter grade</b> for this project?", :inline_format => true
        text "#{letter_grade_ude}"
        move_down 10
        text "What is your <b>DKR letter grade</b> for this project?", :inline_format => true
        text "#{letter_grade_dkr}"
      end
      
      start_new_page
      font_size 14
      text "Families or Youth", :style => :bold 
      font_size 10
      move_down 10
      text "Does your project work with Families or Youth?"
      var_project_work_with_families_youth = ""
      move_down 5
      if project_work_with_families_youth.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_project_work_with_families_youth = project_work_with_families_youth
        text "#{var_project_work_with_families_youth}"
      end
      if var_project_work_with_families_youth == "Yes"
        move_down 10
        text "Do you have a policy in place, staff assigned to inform clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form or process to document this?"
        var_and_form_process_document_this = ""
        move_down 5
        if and_form_process_document_this.nil?
          text "#{not_provided_text}", :inline_format => true
        else
          var_and_form_process_document_this = and_form_process_document_this
          text "#{var_and_form_process_document_this}"
        end
        if var_and_form_process_document_this == "No or Not Applicable"
          move_down 10
          text "Since you have indicated 'No or Not Applicable' to the prior question, please explain."
          move_down 5
          if applicable_prior_question_please_explain.nil?
            text "#{not_provided_text}", :inline_format => true
          else
            text "#{applicable_prior_question_please_explain}"
          end
        end
      end
      
      start_new_page
      font_size 14
      text "HUD Continuum Goals", :style => :bold 
      font_size 10
      move_down 10
      text "The next few questions are based on Continuum Goals set by HUD and subject to change once the 2012 NOFA is released. Please use the figures reported in your most recent Annual Progress Report (APR) submitted to HUD and <b>attach an electronic copy of the APR below</b>.", :inline_format => true
      move_down 5
      if attachment_info_apr.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        text "APR Report attached: #{attachment_info_apr}"
      end
      move_down 10
      text "What was your Average Daily Bed Utilization reported in your most recent APR?"
      move_down 5
      var_reported_your_most_recent_apr = 0
      if reported_your_most_recent_apr.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_reported_your_most_recent_apr = reported_your_most_recent_apr
        text "#{var_reported_your_most_recent_apr}%"
      end
      move_down 10
      if var_reported_your_most_recent_apr.to_f < 85 && if_below_85_please_explain.nil?
        text "If below 85%, please explain:"
        move_down 5
        text "#{not_provided_text}", :inline_format => true
      end
      if !if_below_85_please_explain.nil? #render even if the value was > 85
        text "If below 85%, please explain:"
        move_down 5
        text "#{if_below_85_please_explain}"
      end
      move_down 10
      text "What percentage of your tenants were employed at program at exit?"
      move_down 5
      var_employed_at_program_at_exit = 0
      if employed_at_program_at_exit.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_employed_at_program_at_exit = employed_at_program_at_exit
        text "#{var_employed_at_program_at_exit}%"
      end
      move_down 10
      if var_employed_at_program_at_exit.to_f < 85 && less_than_20_please_explain.nil?
        text "If less than 20%, please explain:"
        move_down 5
        text "#{not_provided_text}", :inline_format => true
      end
      if !less_than_20_please_explain.nil? #render even if the value was < 85
        text "If less than 20%, please explain:"
        move_down 5
        text "#{less_than_20_please_explain}"
      end
      move_down 10
      text "Does your project involve <u>Transitional</u> Housing Projects?", :inline_format => true
      move_down 5
      var_project_involve_transitional_housing_projects = ""
      if project_involve_transitional_housing_projects.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_project_involve_transitional_housing_projects = project_involve_transitional_housing_projects
        text "#{var_project_involve_transitional_housing_projects}"
      end
      if var_project_involve_transitional_housing_projects == "Yes"
        move_down 10
        text "What percentage of tenants moved from transitional to permanent housing?"
        move_down 5
        var_moved_from_transitional_permanent_housing = 0
        if moved_from_transitional_permanent_housing.nil?
          text "#{not_provided_text}", :inline_format => true
        else
          var_moved_from_transitional_permanent_housing = moved_from_transitional_permanent_housing
          text "#{var_moved_from_transitional_permanent_housing}%"
        end
        move_down 10
        if var_moved_from_transitional_permanent_housing.to_f < 65 && if_below_65_please_explain.nil?
          text "If less than 65%, please explain:"
          move_down 5
          text "#{not_provided_text}", :inline_format => true
        end
        if !if_below_65_please_explain.nil? #render even if the value was < 65
          text "If below 65%, please explain:"
          move_down 5
          text "#{if_below_65_please_explain}"
        end
      end #transitional housing = yes block
      move_down 10
      text "Does your project involve <u>Permanent Supportive</u> Housing Projects?", :inline_format => true
      move_down 5
      var_involve_permanent_supportive_housing_projects = ""
      if involve_permanent_supportive_housing_projects.nil?
        text "#{not_provided_text}", :inline_format => true
      else
        var_involve_permanent_supportive_housing_projects = involve_permanent_supportive_housing_projects
        text "#{var_involve_permanent_supportive_housing_projects}"
      end
    ##
      if var_involve_permanent_supportive_housing_projects == "Yes"
        move_down 10
        text "WWhat percentage of tenants have been in permanent housing over 6 months?"
        move_down 5
        var_permanent_housing_over_6_months = 0
        if permanent_housing_over_6_months.nil?
          text "#{not_provided_text}", :inline_format => true
        else
          var_permanent_housing_over_6_months = permanent_housing_over_6_months
          text "#{var_permanent_housing_over_6_months}%"
        end
        move_down 10
        if var_permanent_housing_over_6_months.to_f < 77 && if_below_77_please_explain.nil?
          text "If less than 77%, please explain:"
          move_down 5
          text "#{not_provided_text}", :inline_format => true
        end
        if !if_below_77_please_explain.nil? #render even if the value was < 77
          text "If below 77%, please explain:"
          move_down 5
          text "#{if_below_77_please_explain}"
        end
      end #supportive housing = yes block      
    ##  
      
      
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
      
      
      pgnum_string = "Page <page> of <total>  #{grantee_name} - #{project_name}" 
      
      options = { :at => [bounds.right - 700, 0],
                    :width => 700,
                    :align => :right,
                    :size => 9,
                    :start_count_at => 1,
                    :color => "999999" }
      number_pages pgnum_string, options
      
  
    end #prawndoc
  
    
  end


  def create_and_put_pdf

    @mcoc_renewal = McocRenewal.find(mcoc_renewal_id)

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
  
  
  
  private
  

  
  def get_response_with_only_one_value(data_export_identifier, response_set_id, survey_section_id)
    tmp_question = Question.find_by_data_export_identifier_and_survey_section_id(data_export_identifier, survey_section_id)
    tmp_question_id = tmp_question.id
    tmp_answer = Answer.find_all_by_question_id(tmp_question_id) #we may have multiple answer values (e.g. yes/no)
    multi_answer_short_text = ""
    tmp_answer_response_class = ""
    if tmp_answer.size > 1
      tmp_answer.each do |answer_item|                      
        tmp_response_item = Response.find_by_answer_id_and_response_set_id(answer_item.id, response_set_id)
        if !tmp_response_item.nil?
          tmp_response = tmp_response_item
          tmp_answer_response_class = answer_item.response_class
          multi_answer_short_text = answer_item.short_text
        end
      end
    else
      tmp_answer_response_class = tmp_answer.first.response_class
      tmp_response = Response.find_by_answer_id_and_response_set_id(tmp_answer.first.id, response_set_id)
    end
    
    @retval = ""
    
    if !tmp_response.nil? 
      if !tmp_response.id.nil? 
        case tmp_answer_response_class
          when "string"
            @retval = tmp_response.string_value
          when "text"
            @retval = tmp_response.text_value
          when "answer" #yes/no values
            @retval = tmp_answer.short_text
        end
        return @retval
      end
    else
      case tmp_answer_response_class
        when "answer" #yes/no values 
          @retval = multi_answer_short_text
      end
    end
  end
  
  #this will be called when we want to get multiple answers with one question - such as question 1 - agency information
  def get_agency_information_response(data_export_identifier, response_set_id, survey_section_id)
    tmp_question = Question.find_by_data_export_identifier_and_survey_section_id("data_agency_info", survey_section_id)
    tmp_question_id = tmp_question.id
    tmp_answer = Answer.find_by_question_id_and_data_export_identifier(tmp_question_id, data_export_identifier)
    tmp_answer_response_class = tmp_answer.response_class
    tmp_response = Response.find_by_answer_id_and_response_set_id(tmp_answer.id, response_set_id)
    @retval = ""
    if !tmp_response.nil? 
      if !tmp_response.id.nil? 
        case tmp_answer_response_class
          when "string"
            @retval = tmp_response.string_value
          when "text"
            @retval = tmp_response.text_value
          when "answer"   #yes/no values
            @retval = tmp_answer.short_text
        end
        return @retval
      end
    end
  end
  
  def get_attachment_info_ude(mcoc_renewal_id)
    tmp_mcoc_renewal = McocRenewal.find(mcoc_renewal_id)
    if !tmp_mcoc_renewal.nil?
      if !tmp_mcoc_renewal.attachment_ude_file_name.nil?
        retval = "#{tmp_mcoc_renewal.attachment_ude_file_name}"
      end
    end
    return retval
  end
  
  def get_attachment_info_apr(mcoc_renewal_id)
    tmp_mcoc_renewal = McocRenewal.find(mcoc_renewal_id)
    if !tmp_mcoc_renewal.nil?
      if !tmp_mcoc_renewal.attachment_apr_file_name.nil?
        retval = "#{tmp_mcoc_renewal.attachment_apr_file_name}"
      end
    end
    return retval
  end

end