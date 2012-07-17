class QuestionnairePdf < Prawn::Document
  
  include Questionnaire::Data
  

  def initialize(user_id, mcoc_renewal_id, response_set_code, grantee_name, project_name, doc_name)
      
      @user_id = user_id
      @mcoc_renewal_id = mcoc_renewal_id
      @response_set_code = response_set_code
      @grantee_name = grantee_name
      @project_name = project_name

      response_set = ResponseSet.find_by_access_code(response_set_code)
      @response_set_id = response_set.id
      @survey_id = response_set.survey_id
      
      configure(user_id, mcoc_renewal_id, response_set_code, grantee_name, project_name, doc_name)
      
      get_agency_information_section_values
      get_program_information_section_values
      get_hmis_information_section_values
      get_families_youth_section_values
      get_hud_section_values
      get_physical_plant_section_values
      final_section_values
      
      @not_provided_text = "<b><color rgb='ff0000'>Not Provided</color></b>"
      
      super(top_margin: 50)
      
      #create the pdf - by section
      generate_agency_information_section 
      generate_program_information_section_values
      generate_hmis_information_section_values
      generate_families_youth_section_values
      generate_hud_section_values
      generate_physical_plant_section_values
      generate_final_section_values

      
      pgnum_string = "Page <page> of <total> -- #{@grantee_name} - #{@project_name}" 

      options = { :at => [bounds.left + 0, 0],
                    :width => 700,
                    :align => :left,
                    :size => 9,
                    :start_count_at => 1,
                    :color => "999999" }
      number_pages pgnum_string, options

  end #initialize
  
  def generate_agency_information_section
      #first section - Agency Information
   
      font_size 16
      text "2012 Monitoring and Evaluation", :style => :bold 
      move_down 10
      font_size 14
      text "Grantee Name:", :style => :bold
      move_down 5
      text "#{@grantee_name}"
      move_down 10
      text "Project Name:", :style => :bold
      move_down 5
      text "#{@project_name}"
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
      font "Times-Roman"
      if @agency_name.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@agency_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Program Name", :style => :bold 
      font "Times-Roman"
      if @program_name.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@program_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Project Address(es)", :style => :bold 
      font "Times-Roman"
      if @project_address.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@project_address}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Contact Person", :style => :bold 
      font "Times-Roman"
      if @contact_person.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@contact_person}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Phone Number", :style => :bold 
      font "Times-Roman"
      if @phone_number.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@phone_number}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "E-mail Address", :style => :bold 
      font "Times-Roman"
      if @e_mail_address.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@e_mail_address}"
      end 
      font "Helvetica"  # back to normal
      move_down 50
      #legend
      bounding_box [175, cursor], :width => 350 do
        move_down 10
        indent(10) do
          text "<b>Legend</b>", :inline_format => true
          move_down 10
          indent(5) do
            text "Questions are displayed using this style."
            move_down 5
            font "Times-Roman"
            text "Answers are displayed using this style."
            font "Helvetica"  # back to normal
            move_down 5
            text "<font name='Times-Roman'>'#{@not_provided_text}'</font> will display if required information was not furnished.", :inline_format => true
          end
        end
        move_down 10
        transparent(0.3) { stroke_bounds }
      end
    
  end
  
  def generate_program_information_section_values
     start_new_page
     font_size 14
     text "Program Information", :style => :bold 
     font_size 10
     move_down 10
     text "Please answer the following questions in regard to the program during the Operating Year covered by your most recently submitted HUD APR:"
     move_down 10
     text "1) Please provide a brief program summary. Include information about the type of program, population served, and the specific services or operations for which the McKinney-Vento funding was used."
     move_down 5
     font "Times-Roman"
     if @data_program_info.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       text "#{@data_program_info}"
     end
     font "Helvetica"  # back to normal
     move_down 10
     text "2) Please describe how project participants have been assisted to access Mainstream resources, increase incomes and maximize their ability to live independently? (In your narrative, please make specific reference to relevant sections of your APR)."
     move_down 5
     font "Times-Roman"
     if @self_suff.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       text "#{@self_suff}"
     end
     font "Helvetica"  # back to normal
     move_down 10
     text "3) Projects are required to verify homeless and chronic homeless status during intake. Please describe your verification process."
     move_down 5
     font "Times-Roman"
     if @program_verif_proc.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       text "#{@program_verif_proc}"
     end
     font "Helvetica"  # back to normal
     move_down 10
     text "4) What percentage of your total budget for THIS program does the McKinney-Vento renewal represent?"
     move_down 5
     font "Times-Roman"
     if @program_renewal_budget_pct.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       text "#{@program_renewal_budget_pct}"
     end
     font "Helvetica"  # back to normal
  end
  
  def generate_hmis_information_section_values
     start_new_page
     font_size 14
     text "HMIS Participation", :style => :bold 
     font_size 10
     move_down 10
     text "Is your project participating in the Maine HMIS (Homeless Management Information System)?"
     move_down 5
     var_hmis_particp = ""
     font "Times-Roman"
     if @participating_maine_hmis.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       var_hmis_particp = @participating_maine_hmis
       text "#{var_hmis_particp}"
     end
     font "Helvetica"  # back to normal
     if var_hmis_particp == "Yes"
       move_down 10
       text "Please follow this link to a video that will explain how to run the 'UDE Data Completeness Report', and how to make any corrections or updates needed to improve your data completeness."
       move_down 5
       formatted_text [{:text =>"CoC UDE Data Completeness and DKR Reports Video",
                        :color => "0000FF"}]
       move_down 5
       text "Run the report for this facility (which is up for renewal this year) <b><u>and upload an electronic copy of the report below. Please run the UDE Data Completeness Report for the same time frame as your most recent APR Operating Year for each program.</u></b>", :inline_format => true
       move_down 10
       font "Times-Roman"
       if @attachment_info_ude.nil?
         text "UDE Data Completeness Report:"
         text "#{@not_provided_text}", :inline_format => true
       else
         if @attachment_info_ude == "text"
           text "UDE Data Completeness Report:"
           text "#{@not_provided_text}", :inline_format => true
         else
           text "UDE Data Completeness Report uploaded: #{@attachment_info_ude}"
         end
       end
       font "Helvetica"  # back to normal
       move_down 10 
       text "What is your <b>UDE Data Completeness letter grade</b> for this project?", :inline_format => true
       move_down 5
       font "Times-Roman"
       if @letter_grade_ude.nil?
         text "#{@not_provided_text}", :inline_format => true
       else
         text "#{@letter_grade_ude}"
       end
       font "Helvetica"  # back to normal
       move_down 10
       text "What is your <b>DKR letter grade</b> for this project?", :inline_format => true
       move_down 5
       font "Times-Roman"
       if @letter_grade_dkr.nil?
         text "#{@not_provided_text}", :inline_format => true
       else
         text "#{@letter_grade_dkr}"
       end
       font "Helvetica"  # back to normal
     end
  end
  
  def generate_families_youth_section_values
     start_new_page
     font_size 14
     text "Families or Youth", :style => :bold 
     font_size 10
     move_down 10
     text "Does your project work with Families or Youth?"
     var_project_work_with_families_youth = ""
     move_down 5
     font "Times-Roman"
     if @project_work_with_families_youth.nil?
       text "#{@not_provided_text}", :inline_format => true
     else
       var_project_work_with_families_youth = @project_work_with_families_youth
       text "#{var_project_work_with_families_youth}"
     end
     font "Helvetica"  # back to normal
     if var_project_work_with_families_youth == "Yes"
       move_down 10
       text "Do you have a policy in place, staff assigned to inform clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form or process to document this?"
       var_and_form_process_document_this = ""
       move_down 5
       font "Times-Roman"
       if @and_form_process_document_this.nil?
         text "#{@not_provided_text}", :inline_format => true
       else
         var_and_form_process_document_this = @and_form_process_document_this
         text "#{var_and_form_process_document_this}"
       end
       font "Helvetica"  # back to normal
       if var_and_form_process_document_this == "No or Not Applicable"
         move_down 10
         text "Since you have indicated 'No or Not Applicable' to the prior question, please explain."
         move_down 5
         font "Times-Roman"
         if @applicable_prior_question_please_explain.nil?
           text "#{@not_provided_text}", :inline_format => true
         else
           text "#{@applicable_prior_question_please_explain}"
         end
         font "Helvetica"  # back to normal
       end
     end
  end
  
  def generate_hud_section_values
      start_new_page
      font_size 14
      text "HUD Continuum Goals", :style => :bold 
      font_size 10
      move_down 10
      text "The next few questions are based on Continuum Goals set by HUD and subject to change once the 2012 NOFA is released. Please use the figures reported in your most recent Annual Progress Report (APR) submitted to HUD and <b>upload an electronic copy of the APR below</b>.", :inline_format => true
      move_down 5
      font "Times-Roman"
      if @attachment_info_apr.nil?
        text "APR Report:"
        text "#{@not_provided_text}", :inline_format => true
      else
        if attachment_info_apr == "text"
          text "APR Report:"
          text "#{@not_provided_text}", :inline_format => true
        else
          text "APR Report uploaded: #{attachment_info_apr}"
        end
      end
      font "Helvetica"  # back to normal
      move_down 10
      text "What was your Average Daily Bed Utilization reported in your most recent APR?"
      move_down 5
      var_reported_your_most_recent_apr = 0
      font "Times-Roman"
      if @reported_your_most_recent_apr.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        var_reported_your_most_recent_apr = @reported_your_most_recent_apr
        text "#{var_reported_your_most_recent_apr}%"
      end
      font "Helvetica"  # back to normal
      move_down 10
      if var_reported_your_most_recent_apr.to_f < 85 && @if_below_85_please_explain.nil?
        text "If below 85%, please explain:"
        move_down 5
        font "Times-Roman"
        text "#{@not_provided_text}", :inline_format => true
        font "Helvetica"  # back to normal
      end
      if !@if_below_85_please_explain.nil? #render even if the value was > 85
        text "If below 85%, please explain:"
        move_down 5
        font "Times-Roman"
        text "#{@if_below_85_please_explain}"
        font "Helvetica"  # back to normal
      end
      move_down 10
      text "What percentage of your tenants were employed at program at exit?"
      move_down 5
      var_employed_at_program_at_exit = 0
      font "Times-Roman"
      if @employed_at_program_at_exit.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        var_employed_at_program_at_exit = @employed_at_program_at_exit
        text "#{var_employed_at_program_at_exit}%"
      end
      font "Helvetica"  # back to normal
      move_down 10
      if var_employed_at_program_at_exit.to_f < 85 && @less_than_20_please_explain.nil?
        text "If less than 20%, please explain:"
        move_down 5
        font "Times-Roman"
        text "#{@not_provided_text}", :inline_format => true
        font "Helvetica"  # back to normal
      end
      if !@less_than_20_please_explain.nil? #render even if the value was < 85
        text "If less than 20%, please explain:"
        move_down 5
        font "Times-Roman"
        text "#{@less_than_20_please_explain}"
        font "Helvetica"  # back to normal
      end
      move_down 10
      text "Does your project involve <u>Transitional</u> Housing Projects?", :inline_format => true
      move_down 5
      var_project_involve_transitional_housing_projects = ""
      font "Times-Roman"
      if @project_involve_transitional_housing_projects.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        var_project_involve_transitional_housing_projects = @project_involve_transitional_housing_projects
        text "#{var_project_involve_transitional_housing_projects}"
      end
      font "Helvetica"  # back to normal
      if var_project_involve_transitional_housing_projects == "Yes"
        move_down 10
        text "What percentage of tenants moved from transitional to permanent housing?"
        move_down 5
        var_moved_from_transitional_permanent_housing = 0
        font "Times-Roman"
        if @moved_from_transitional_permanent_housing.nil?
          text "#{@not_provided_text}", :inline_format => true
        else
          var_moved_from_transitional_permanent_housing = @moved_from_transitional_permanent_housing
          text "#{var_moved_from_transitional_permanent_housing}%"
        end
        font "Helvetica"  # back to normal
        move_down 10
        if var_moved_from_transitional_permanent_housing.to_f < 65 && @if_below_65_please_explain.nil?
          text "If less than 65%, please explain:"
          move_down 5
          font "Times-Roman"
          text "#{@not_provided_text}", :inline_format => true
          font "Helvetica"  # back to normal
        end
        if !@if_below_65_please_explain.nil? #render even if the value was < 65
          text "If below 65%, please explain:"
          move_down 5
          font "Times-Roman"
          text "#{@if_below_65_please_explain}"
          font "Helvetica"  # back to normal
        end
      end #transitional housing = yes block
      move_down 10
      text "Does your project involve <u>Permanent Supportive</u> Housing Projects?", :inline_format => true
      move_down 5
      var_involve_permanent_supportive_housing_projects = ""
      font "Times-Roman"
      if @involve_permanent_supportive_housing_projects.nil?
        text "#{@not_provided_text}", :inline_format => true
      else
        var_involve_permanent_supportive_housing_projects = @involve_permanent_supportive_housing_projects
        text "#{var_involve_permanent_supportive_housing_projects}"
      end
      font "Helvetica"  # back to normal
      if var_involve_permanent_supportive_housing_projects == "Yes"
        move_down 10
        text "What percentage of tenants have been in permanent housing over 6 months?"
        move_down 5
        var_permanent_housing_over_6_months = 0
        font "Times-Roman"
        if @permanent_housing_over_6_months.nil?
          text "#{@not_provided_text}", :inline_format => true
        else
          var_permanent_housing_over_6_months = @permanent_housing_over_6_months
          text "#{var_permanent_housing_over_6_months}%"
        end
        font "Helvetica"  # back to normal
        move_down 10
        if var_permanent_housing_over_6_months.to_f < 77 && @if_below_77_please_explain.nil?
          text "If less than 77%, please explain:"
          move_down 5
          font "Times-Roman"
          text "#{@not_provided_text}", :inline_format => true
          font "Helvetica"  # back to normal
        end
        if !@if_below_77_please_explain.nil? #render even if the value was < 77
          text "If below 77%, please explain:"
          move_down 5
          font "Times-Roman"
          text "#{@if_below_77_please_explain}"
          font "Helvetica"  # back to normal
        end
      end #supportive housing = yes block
  end
  
  def generate_physical_plant_section_values
      start_new_page
      font_size 14
      text "Physical Plant", :style => :bold 
      font_size 10
      move_down 10
      text "Please indicate if any of the agencies below conduct site visits for this program. If so, please list the date of last inspection and status of that inspection. If there are any unresolved findings or other issues, please explain briefly how they were or will be resolved and upload relevant documentation (at the bottom of this page)."
      move_down 10
      text "Fire Marshall", :style => :bold 
      data_headers = [["Site Visit?", "Date of last inspection?", "Pass or Fail?"]]
      data_headers1 = [["Name","Site Visit?", "Date of 160, 160, 160last inspection?", "Pass or Fail?"]]
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"     
      table @data_fire_marshall, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
      font "Helvetica"  # back to normal
      move_down 10
      text "DHHS Licensing", :style => :bold 
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"
      table @data_dhhs, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
      font "Helvetica"  # back to normal
      move_down 10
      text "MaineHousing", :style => :bold 
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"
      table @data_msha, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
      font "Helvetica"  # back to normal
      move_down 10
      text "CARF", :style => :bold 
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"
      table @data_carf, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
      font "Helvetica"  # back to normal
      move_down 10
      text "HUD", :style => :bold 
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"
      table @data_hud, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
      font "Helvetica"  # back to normal
      move_down 10
      text "HQS", :style => :bold 
      table(data_headers, :column_widths => [160, 160, 160])
      font "Times-Roman"
      table @data_hqs, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }   
      font "Helvetica"  # back to normal 
      if !@name_other1.nil?
        move_down 10
        text @name_other1, :style => :bold 
        table(data_headers, :column_widths => [160, 160, 160])
        font "Times-Roman"
        table @data_other1, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
        font "Helvetica"  # back to normal
      end
      if !@name_other2.nil?
        move_down 10
        text @name_other2, :style => :bold 
        table(data_headers, :column_widths => [160, 160, 160])
        font "Times-Roman"
        table @data_other2, :column_widths => [160, 160, 160], :cell_style => { :inline_format => true }
        font "Helvetica"  # back to normal
      end
      move_down 10
      text "Physical plant narrative (if necessary). If there are any unresolved findings or other issues, please explain briefly how they were or will be resolved and upload relevant documentation."
      move_down 5
      font "Times-Roman"
      text "#{@phys_plant_narrative}"
      font "Helvetica"  # back to normal

      font "Times-Roman"
      if !@attachment_info_other.nil?
        move_down 10
        if @attachment_info_other.length > 0
          text "Relevant and Supporting Documentation uploaded:\n #{attachment_info_other}", :inline_format => true
        else
          text "Relevant and Supporting Documentation: Not Applicable (no attachments uploaded)"
        end
      else
        move_down 10
        text "Relevant and Supporting Documentation: Not Applicable (no attachments uploaded)"
      end
      font "Helvetica"  # back to normal
  end
  
  def generate_final_section_values
      start_new_page
      font_size 14
      text "Finish", :style => :bold 
      font_size 10
      move_down 10
      text "Please provide the following information to complete the Monitoring and Evaluation questionnaire:"
      move_down 5
      text "<i>All information submitted is true and accurate to the best of my knowledge.</i>", :inline_format => true
      move_down 10
      text "Prepared By", :style => :bold
      move_down 5
      text "First Name"
      font "Times-Roman"
      if @preparer_first_name.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@preparer_first_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Last Name"
      font "Times-Roman"
      if @preparer_last_name.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@preparer_last_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Title"
      font "Times-Roman"
      if @preparer_title.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@preparer_title}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      if !@preparer_email_address.nil? || !@preparer_phone_number.nil?
        text "(If different from agency/program contact information):"
        move_down 5
        text "Email Address"
        font "Times-Roman"
        if @preparer_email_address.nil?
        else
          text "#{@preparer_email_address}"
        end
        font "Helvetica"  # back to normal      
        move_down 5
        text "Phone number"
        font "Times-Roman"
        if @preparer_phone_number.nil?
        else
          text "#{@preparer_phone_number}"
        end
        font "Helvetica"  # back to normal     
      end 
      move_down 10
      text "Executive Director Information", :style => :bold
      move_down 5
      text "Executive Director First Name"
      font "Times-Roman"
      if @execdir_first_name.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@execdir_first_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Executive Director Last Name"
      font "Times-Roman"
      if @execdir_last_name.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@execdir_last_name}"
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "Executive Director Email Address"
      font "Times-Roman"
      if @execdir_email_address.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@execdir_email_address}"
      end
      font "Helvetica"  # back to normal
      move_down 10
      text "Electronic Signature", :style => :bold
      move_down 5
      text "By checking this box:"   
      move_down 5  
      font "Times-Roman"
      if @elect_sig_checkval.length == 0
         text "#{@not_provided_text} - I hereby indicate the information contained in this questionnaire is true and correct to the best of my knowledge", :inline_format => true
      else
        text "#{@elect_sig_checkval} - I hereby indicate the information contained in this questionnaire is true and correct to the best of my knowledge."
      end
      font "Helvetica"  # back to normal
      move_down 5
      text "By typing my name in the following space, I certify that I am authorized to submit this questionnaire. I further certify that this questionnaire is submitted with full knowledge and consent of my agency's Executive Director or other governing body."
      move_down 5
      font "Times-Roman"
      if @elect_sig_name.nil?
         text "#{@not_provided_text}", :inline_format => true
      else
        text "#{@elect_sig_name}"
      end
      font "Helvetica"  # back to normal
    end

  
end