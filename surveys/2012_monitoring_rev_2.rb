survey "2012 Monitoring and Evaluation" do
  section "Agency Information" do
      # A label is a question that accepts no answers
      
      label "<b>Instructions:</b> Please complete this form if your agency intends to apply for 
      Renewal McKinney Vento Funding through the Maine Continuum of Care in 2012. 
      If you do not intend to apply for renewal funding, please let us know. 
      All forms and appropriate attachments must be received electronically 
      by {{recipient_name}} no later than {{deadline_date}}.
      Please direct all questions to: {{recipient_email_address}}. 
      A separate form must be completed for EACH program/project seeking renewal."
      
      # Surveys, sections, questions, groups, and answers all take the following reference arguments
      # :reference_identifier   # usually from paper
      # :data_export_identifier # data export
      # :common_namespace       # maping to a common vocab
      # :common_identifier      # maping to a common vocab
      q_1 "Agency Information", :custom_class => 'c_q1', :reference_identifier => "ref_agency_info", :data_export_identifier => "data_agency_info", :common_namespace => "Agency Information", :common_identifier => "Agency Information"
      a_1 "Agency Name", :string
      a_1 "Program Name", :string
      a_1 "Project Address(es)", :text
      a_1 "Contact Person", :string
      a_1 "Phone Number", :string
      a_1 "E-mail Address", :string  
  end #section Agency Information 
  section "Program Information" do
      # A label is a question that accepts no answers
      label "<b>Please answer the following questions in regard to the program during the Operating Year 
      covered by your most recently submitted HUD APR:</b><br/>"
      q_2 "Please provide a brief program summary. Include information about the type of program, population  
      served, and the specific services or operations for which the McKinney-Vento funding was used", :custom_class => 'c_q2', :reference_identifier => "ref_program_info", :data_export_identifier => "data_program_info", :common_namespace => "Program Information", :common_identifier => "Program Information"
      a_2 :text
      q_3 "Please describe how project participants have been assisted to access Mainstream resources, increase incomes and maximize their 
         ability to live independently? (In your narrative, please make specific reference to relevant sections of your APR)", :custom_class => 'c_q3', 
         :reference_identifier => "ref_self_suff", :data_export_identifier => "self_suff", :common_namespace => "Self Sufficiency", 
         :common_identifier => "Self Sufficiency"
      a_3 :text
      q_4 "Projects are required to verify homeless and chronic homeless status during intake. Please describe your verification process.", :custom_class => 'c_q4', :reference_identifier => "program_verif_proc", :data_export_identifier => "program_verif_proc", :common_namespace => "Program Verification Process", :common_identifier => "Program Verification Process"
      a_4 :text
      q_5 "What percentage of your total budget for THIS program does the McKinney-Vento renewal represent?", :custom_class => 'c_q5', :reference_identifier => "program_renewal_budget_pct", :data_export_identifier => "program_renewal_budget_pct", :common_namespace => "Percentage of Total Budget"
      a_5 :text
  end #section Program Information 
  section "HMIS Participation" do
      q_6 "Is your project participating in the Maine HMIS (Homeless Management Information System)?", :custom_class => 'c_q6', :pick => :one
      a_y "Yes"
      a_n "No"

      q_8 "Please follow this link to a video that will explain how to run the “UDE Data Completeness Report”, and how to 
            make any corrections or updates needed to improve your data completeness.
            <br/><br/>
            <a target='_blank' href='http://mainehmis.org/2011/12/07/coc-ude-data-completeness-and-dkr-reports-video/'>CoC UDE Data Completeness and DKR Reports Video</a>
            <br/><br/>Run the report for this facility (which is up for renewal this year) and <b><u>attach an electronic copy of the report below</u></b>.
            <b>Please run the UDE Data Completeness Report for the same time frame as your most recent APR Operating Year for each program.</b><br/>
            <br/><br/>
            <iframe id='ude_upload' name='ude_upload' src='attachments/ude_report'></iframe>
            <br/>
            What is your <b>UDE Data Completeness letter grade</b> for this project?
            ", :custom_class => 'c_q8', :data_export_identifier => 'letter_grade_ude'
      a_8 :string
      dependency :rule => "B"
      condition_B :q_6, "==", :a_y
      
      q_9 "What is your <b>DKR letter grade</b> for this project?", :custom_class => 'c_q9', :data_export_identifier => 'letter_grade_dkr'
      a_9 :string
      dependency :rule => "Z"
      condition_Z :q_6, "==", :a_y
      
  end #section HMIS
  
  section "Families or Youth" do
      q_10 "Does your project work with Families or Youth?", :custom_class => 'c_q10', :pick => :one
      a_y "Yes"
      a_n "No"
    
      q_11 "Do you have a policy in place, staff assigned to inform
            clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form or 
            process to document this?", :custom_class => 'c_q11',:pick => :one
      a_y "Yes"
      a_n "No or Not Applicable"
      dependency :rule => "C"
      condition_C :q_10, "==", :a_y
 
      q_12 "Since you have indicated 'No or Not Applicable' to the prior question, please explain.", :custom_class => 'c_q12'
      a_12 :text
      dependency :rule => "D"
      condition_D :q_11, "==", :a_n
      
  end #section Families or Youth
  
  section "HUD Continuum Goals" do
      label "The next few questions are based on Continuum Goals set by HUD and subject to change once the 2012 NOFA is released.
           Please use the figures reported in your <u>most recent</u> Annual Progress Report (APR) submitted to HUD and 
           <b>attach an electronic copy of the APR below</b>.
           <br/><br/>
           <iframe id='apr_upload' name='apr_upload' src='attachments/apr_report'></iframe>
           <br/>"
           
      q_13 "What was your Average Daily Bed Utilization reported in your most recent APR?", :custom_class => 'c_q13'
      a_13 "|%", :string
      
      q_14 "If below 85%, please explain:", :custom_class => 'c_q14'
      a_14 :text
      
      q_15 "What percentage of your tenants were employed at program at exit?", :custom_class => 'c_q15'
      a_15 "|%", :string
      
      q_16 "If less than 20%, please explain:", :custom_class => 'c_q16'
      a_16 :text
      
      q_17 "Does your project involve <u>Transitional</u> Housing Projects?", :custom_class => 'c_q17', :pick => :one
      a_y "Yes"
      a_n "No"
      
      q_18 "What percentage of tenants moved from transitional to permanent housing?", :custom_class => 'c_q18'
      a_18 "|%", :string
      dependency :rule => "E"
      condition_E :q_17, "==", :a_y
      
      q_19 "If below 65%, please explain:", :custom_class => 'c_q19'
      a_19 :text
      dependency :rule => "F"
      condition_F :q_17, "==", :a_y
      
      q_20 "Does your project involve <u>Permanent Supportive</u> Housing Projects?", :custom_class => 'c_q20', :pick => :one
      a_y "Yes"
      a_n "No"
      
      q_21 "What percentage of tenants have been in permanent housing over 6 months?", :custom_class => 'c_q21'
      a_21 "|%", :string
      dependency :rule => "G"
      condition_G :q_20, "==", :a_y
      
      q_22 "If below 77%, please explain:", :custom_class => 'c_q22'
      a_22 :text
      dependency :rule => "H"
      condition_H :q_20, "==", :a_y
        
  end #section HUD Continuum Goals
  
  section "Physical Plant" do
      label "Please indicate if any of the agencies below conduct site visits for this program. If so, please
            list the date of last inspection and status of that inspection. If there are any unresolved 
            findings or other issues, please explain briefly how they were or will be resolved and upload
            relevant documentation (at the bottom of this page)."

      group "Fire Marshall", :display_type => :inline do  
        q_23 "Site visit?", :custom_class => 'c_q23', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_fire_marshall'
          a_23_y "Yes"
          a_23_n "No"
        q_24 "Date of last inspection", :custom_class => 'c_q24', :display_type => :inline, :data_export_identifier => 'inspection_date_fire_marshall'
        a_24 :date
        q_25 "Pass or Fail?", :custom_class => 'c_q25', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_fail_fire_marshall'
        a_25_y "Pass", :data_export_identifier => 'fire_marshall_pass'
        a_25_n "Fail", :data_export_identifier => 'fire_marshall_fail'
        a_25_x "Not Applicable", :data_export_identifier => 'fire_marshall_na'
        
        q_26 "Fire Marshall - Not Applicable Reason", :custom_class => 'c_q26txt'
        a_26 :text, :data_export_identifier => 'fire_marshall_na_reason'
        dependency :rule => "I"
        condition_I :q_25, "==", :a_25_x

      end
      
      group "DHHS Licensing", :display_type => :inline do  
        q_27 "Site visit?", :custom_class => 'c_q27', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_dhhs'
          a_27_y "Yes"
          a_27_n "No"
        q_28 "Date of last inspection", :custom_class => 'c_q28', :display_type => :inline, :data_export_identifier => 'inspection_date_dhhs'
        a_28 :date
        q_29 "Pass or Fail?", :custom_class => 'c_q29', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_fail_dhhs'
        a_29_y "Pass", :data_export_identifier => 'dhhs_pass'
        a_29_n "Fail", :data_export_identifier => 'dhhs_fail'
        a_29_x "Not Applicable", :data_export_identifier => 'dhhs_na'
        
        q_30 "DHHS - Not Applicable Reason", :custom_class => 'c_q30txt'
        a_30 :text, :data_export_identifier => 'dhhs_na_reason'
        dependency :rule => "J"
        condition_J :q_29, "==", :a_29_x
        
      end
      
      group "MaineHousing", :display_type => :inline do  
        q_31 "Site visit?", :custom_class => 'c_q31', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_msha'
          a_31_y "Yes"
          a_31_n "No"
        q_32 "Date of last inspection", :custom_class => 'c_q32', :display_type => :inline, :data_export_identifier => 'inspection_date_msha'
        a_32 :date
        q_33 "Pass or Fail?", :custom_class => 'c_q33', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_fail_msha'
        a_33_y "Pass", :data_export_identifier => 'msha_pass'
        a_33_n "Fail", :data_export_identifier => 'msha_fail'
        a_33_x "Not Applicable", :data_export_identifier => 'msha_na'
        
        q_34 "MaineHousing - Not Applicable Reason", :custom_class => 'c_q34txt'
        a_34 :text, :data_export_identifier => 'dhhs_na_reason'
        dependency :rule => "J"
        condition_J :q_33, "==", :a_33_x
        
      end
      
      group "CARF", :display_type => :inline do  
        q_35 "Site visit?", :custom_class => 'c_q35', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_carf'
          a_32_y "Yes"
          a_32_n "No"
        q_36 "Date of last inspection", :custom_class => 'c_q36', :display_type => :inline, :data_export_identifier => 'inspection_date_carf'
        a_36 :date
        q_37 "Pass or Fail?", :custom_class => 'c_q37', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_or_fail_carf'
        a_37_y "Pass", :data_export_identifier => 'carf_pass'
        a_37_n "Fail", :data_export_identifier => 'carf_fail'
        a_37_x "Not Applicable", :data_export_identifier => 'carf_na'
        
        q_38 "CARF - Not Applicable Reason", :custom_class => 'c_q38txt'
        a_38 :text, :data_export_identifier => 'carf_na_reason'
        dependency :rule => "K"
        condition_K :q_37, "==", :a_37_x
        
      end
      
      group "HUD", :display_type => :inline do  
        q_39 "Site visit?", :custom_class => 'c_q39', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_hud'
          a_39_y "Yes"
          a_39_n "No"
        q_40 "Date of last inspection", :custom_class => 'c_q40', :display_type => :inline, :data_export_identifier => 'inspection_date_hud'
        a_40 :date
        q_41 "Pass or Fail?", :custom_class => 'c_q41', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_or_fail_hud'
        a_41_y "Pass", :data_export_identifier => 'hud_pass'
        a_41_n "Fail", :data_export_identifier => 'hud_fail'
        a_41_x "Not Applicable", :data_export_identifier => 'hud_na'
        
        q_42 "HUD - Not Applicable Reason", :custom_class => 'c_q42txt'
        a_42 :text, :data_export_identifier => 'hud_na_reason'
        dependency :rule => "L"
        condition_L :q_41, "==", :a_41_x
        
      end
      
      group "HQS", :display_type => :inline do  
        q_43 "Site visit?", :custom_class => 'c_q43', :pick => :one, :display_type => :inline,  :data_export_identifier => 'site_visit_hqs'
          a_43_y "Yes"
          a_43_n "No"
        q_44 "Date of last inspection", :custom_class => 'c_q44', :display_type => :inline,  :data_export_identifier => 'inspection_date_hqs'
        a_44 :date
        q_45 "Pass or Fail?", :custom_class => 'c_q45', :pick => :one, :display_type => :inline,  :data_export_identifier => 'pass_or_fail_hqs'
        a_45_y "Pass", :data_export_identifier => 'hqs_pass'
        a_45_n "Fail", :data_export_identifier => 'hqs_fail'
        a_45_x "Not Applicable", :data_export_identifier => 'hqs_na'
        
        q_46 "HQS - Not Applicable Reason", :custom_class => 'c_q46txt'
        a_46 :text, :data_export_identifier => 'hqs_na_reason'
        dependency :rule => "M"
        condition_M :q_45, "==", :a_45_x
        
      end
      
      group "Other agency", :display_type => :inline do  
        q_47 "Name", :custom_class => 'c_q47', :display_type => :inline, :data_export_identifier => 'name_other1'
        a_47 :string
        q_48 "Site visit?", :custom_class => 'c_q48', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_other1'
          a_48_y "Yes"
          a_48_n "No"
        q_49 "Date of last inspection", :custom_class => 'c_q49', :display_type => :inline, :data_export_identifier => 'inspection_date_other1'
        a_49 :date
        q_50 "Pass or Fail?", :custom_class => 'c_q50', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_or_fail_other1'
        a_50_y "Pass", :data_export_identifier => 'other1_pass'
        a_50_n "Fail", :data_export_identifier => 'other1_fail'
        a_50_x "Not Applicable", :data_export_identifier => 'other1_na'
        
        q_51 "Other - Not Applicable Reason", :custom_class => 'c_q51txt'
        a_51 :text, :data_export_identifier => 'other1_na_reason'
        dependency :rule => "N"
        condition_N :q_50, "==", :a_50_x
        
      end
      
      group "Other agency", :display_type => :inline do  
        q_52 "Name", :custom_class => 'c_q52', :display_type => :inline, :data_export_identifier => 'name_other2'
        a_52 :string
        q_53 "Site visit?", :custom_class => 'c_q53', :pick => :one, :display_type => :inline, :data_export_identifier => 'site_visit_other2'
          a_53_y "Yes"
          a_53_n "No"
        q_54 "Date of last inspection", :custom_class => 'c_q54', :display_type => :inline, :data_export_identifier => 'inspection_date_other2'
        a_54 :date
        q_55 "Pass or Fail?", :custom_class => 'c_q55', :pick => :one, :display_type => :inline, :data_export_identifier => 'pass_or_fail_other2'
        a_55_y "Pass", :data_export_identifier => 'other2_pass'
        a_55_n "Fail", :data_export_identifier => 'other2_fail'
        a_55_x "Not Applicable", :data_export_identifier => 'other2_na'

        q_56 "Other - Not Applicable Reason", :custom_class => 'c_q56txt'
        a_56 :text, :data_export_identifier => 'other2_na_reason'
        dependency :rule => "N"
        condition_N :q_55, "==", :a_55_x
        
      end
    
      q_56 "Physical plant narrative (if necessary). If there are any unresolved 
      findings or other issues, please explain briefly how they were or will be resolved and upload
      relevant documentation.", :custom_class => 'c_q56'
      a_56 :text
      
      label "<iframe id='additional_doc_upload' name='additional_doc_upload' src='attachments/additional_doc'></iframe>"

  end
  
  section "Finish" do
      label "Please provide the following information to complete the Monitoring and Evaluation questionnaire:"
      label "<i>All information submitted is true and accurate to the best of my knowledge.</i><br/>"
      
      label "<b>Prepared By</b>", :custom_class => 'c_q57' 
      
      q_57 "First Name", :display_type => :inline, :data_export_identifier => 'preparer_first_name'
      a_57 :string

      q_58 "Last Name", :custom_class => 'c_q58', :data_export_identifier => 'preparer_last_name'
      a_58 :string
      
      q_59 "Title", :custom_class => 'c_q59', :data_export_identifier => 'preparer_title'
      a_59 :string

      label "</br>(If different from agency/program contact information):"
      q_60 "Email Address", :custom_class => 'c_q60', :data_export_identifier => 'preparer_email_address'
      a_60 :string

      q_61 "Phone number", :custom_class => 'c_q61', :data_export_identifier => 'preparer_phone_number'
      a_61 :string
 
        
      label "<b>Executive Director Information</b>", :custom_class => 'c_q62'
      
      q_62 "Executive Director First Name", :data_export_identifier => 'execdir_first_name'
      a_62 :string

      q_63 "Executive Director Last Name", :custom_class => 'c_q63', :data_export_identifier => 'execdir_last_name'
      a_63 :string 
      
      q_64 "Executive Director Email Address", :custom_class => 'c_q64', :data_export_identifier => 'execdir_email_address'
      a_64 :string
 
      
      label "<br/><b>Electronic Signature</b><br/>"
   
      q_65 "By checking this box:<br/>", :pick => :any, :data_export_identifier => 'elect_sig_checkval'
      a_65 "I hereby indicate the information contained in this questionnaire is true and 
            correct to the best of my knowledge.", :custom_class => 'c_q65'
            
      label "<br/>"
    
      q_66 "By typing my name in the following space, I certify that I am authorized to submit this questionnaire. I further
            certify that this questionnaire is submitted with full knowledge and consent of my agency's Executive Director or other 
            governing body.<br/><br/>", :custom_class => 'c_q66', :data_export_identifier => 'elect_sig_name'
      a_66 :string
      
      label "<br/>After review, the Monitoring Committee will review your completed questionnaire. The Monitoring Committee may 
             contact you if they have any questions or require more information.<br/><br/>
             Thank you, and feel free to contact {{recipient_email_address}} with any additional questions."

  end
  
end