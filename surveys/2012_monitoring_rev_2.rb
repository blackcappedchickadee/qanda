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
      q_1 "Agency Information", :custom_class => 'c_q1', :reference_identifier => "agency_info", :data_export_identifier => "agency_info", :common_namespace => "Agency Information", :common_identifier => "Agency Information"
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
      served, and the specific services or operations for which the McKinney-Vento funding was used", :custom_class => 'c_q2', :reference_identifier => "program_info", :data_export_identifier => "program_info", :common_namespace => "Program Information", :common_identifier => "Program Information"
      a_2 :text
      q_3 "Please describe how project participants have been assisted to access Mainstream resources, increase incomes and maximize their ability to live independently? (In your narrative, please make specific reference to relevant sections of your APR)", :custom_class => 'c_q3', :reference_identifier => "self_suff", :data_export_identifier => "self_suff", :common_namespace => "Self Sufficiency", :common_identifier => "Self Sufficiency"
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
            ", :custom_class => 'c_q8'
      a_8 :string
      dependency :rule => "B"
      condition_B :q_6, "==", :a_y
      
      q_9 "What is your <b>DKR letter grade</b> for this project?", :custom_class => 'c_q9'
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
      label "The next few questions are based on Continuum Coals set by HUD and subject to change once the 2012 NOFA is released.
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
        q_23 "Site visit?", :custom_class => 'c_q23', :pick => :one, :display_type => :inline
          a_23_y "Yes"
          a_23_n "No"
        q_24 "Date of last inspection", :custom_class => 'c_q24', :display_type => :inline
        a_24 :date
        q_25 "Pass or Fail?", :custom_class => 'c_q25', :pick => :one, :display_type => :inline
        a_25_y "Pass"
        a_25_n "Fail"
      end
      
      group "DHHS Licensing", :display_type => :inline do  
        q_26 "Site visit?", :custom_class => 'c_q26', :pick => :one, :display_type => :inline
          a_26_y "Yes"
          a_26_n "No"
        q_27 "Date of last inspection", :custom_class => 'c_q27', :display_type => :inline
        a_27 :date
        q_28 "Pass or Fail?", :custom_class => 'c_q28', :pick => :one, :display_type => :inline
        a_28_y "Pass"
        a_28_n "Fail"
      end
      
      group "MaineHousing", :display_type => :inline do  
        q_29 "Site visit?", :custom_class => 'c_q29', :pick => :one, :display_type => :inline
          a_29_y "Yes"
          a_29_n "No"
        q_30 "Date of last inspection", :custom_class => 'c_q30', :display_type => :inline
        a_30 :date
        q_31 "Pass or Fail?", :custom_class => 'c_q31', :pick => :one, :display_type => :inline
        a_31_y "Pass"
        a_31_n "Fail"
      end
      
      group "CARF", :display_type => :inline do  
        q_32 "Site visit?", :custom_class => 'c_q32', :pick => :one, :display_type => :inline
          a_32_y "Yes"
          a_32_n "No"
        q_33 "Date of last inspection", :custom_class => 'c_q33', :display_type => :inline
        a_33 :date
        q_34 "Pass or Fail?", :custom_class => 'c_q34', :pick => :one, :display_type => :inline
        a_34_y "Pass"
        a_34_n "Fail"
      end
      
      group "HUD", :display_type => :inline do  
        q_35 "Site visit?", :custom_class => 'c_q35', :pick => :one, :display_type => :inline
          a_35_y "Yes"
          a_35_n "No"
        q_36 "Date of last inspection", :custom_class => 'c_q36', :display_type => :inline
        a_36 :date
        q_37 "Pass or Fail?", :custom_class => 'c_q37', :pick => :one, :display_type => :inline
        a_37_y "Pass"
        a_37_n "Fail"
      end
      
      group "HQS", :display_type => :inline do  
        q_38 "Site visit?", :custom_class => 'c_q38', :pick => :one, :display_type => :inline
          a_38_y "Yes"
          a_38_n "No"
        q_39 "Date of last inspection", :custom_class => 'c_q39', :display_type => :inline
        a_39 :date
        q_40 "Pass or Fail?", :custom_class => 'c_q40', :pick => :one, :display_type => :inline
        a_40_y "Pass"
        a_40_n "Fail"
      end
      
      group "Other agency", :display_type => :inline do  
        q_41 "Name", :custom_class => 'c_q41', :display_type => :inline
        a_41 :string
        q_42 "Site visit?", :custom_class => 'c_q42', :pick => :one, :display_type => :inline
          a_42_y "Yes"
          a_42_n "No"
        q_43 "Date of last inspection", :custom_class => 'c_q43', :display_type => :inline
        a_43 :date
        q_44 "Pass or Fail?", :custom_class => 'c_q44', :pick => :one, :display_type => :inline
        a_44_y "Pass"
        a_44_n "Fail"
      end
      
      group "Other agency", :display_type => :inline do  
        q_45 "Name", :custom_class => 'c_q45', :display_type => :inline
        a_45 :string
        q_46 "Site visit?", :custom_class => 'c_q46', :pick => :one, :display_type => :inline
          a_46_y "Yes"
          a_46_n "No"
        q_47 "Date of last inspection", :custom_class => 'c_q47', :display_type => :inline
        a_47 :date
        q_48 "Pass or Fail?", :custom_class => 'c_q48', :pick => :one, :display_type => :inline
        a_48_y "Pass"
        a_48_n "Fail"
      end
    
      q_49 "Physical plant narrative (if necessary). If there are any unresolved 
      findings or other issues, please explain briefly how they were or will be resolved and upload
      relevant documentation.", :custom_class => 'c_q49'
      a_49 :text
      
      label "<iframe id='additional_doc_upload' name='additional_doc_upload' src='attachments/additional_doc'></iframe>"

  end
  
  section "Finish" do
      label "Please provide the following information to complete the Monitoring and Evaluation questionnaire:"
      label "<i>All information submitted is true and accurate to the best of my knowledge.</i><br/>"
      
      label "<b>Prepared By</b>", :custom_class => 'c_q50' 
      
      q_50 "First Name", :display_type => :inline
      a_50 :string

      q_51 "Last Name", :custom_class => 'c_q51'
      a_51 :string
      
      q_52 "Title", :custom_class => 'c_q52'
      a_52 :string

      label "</br>(If different from agency/program contact information):"
      q_53 "Email Address", :custom_class => 'c_q53'
      a_53 :string

      q_54 "Phone number", :custom_class => 'c_q54'
      a_54 :string
 
        
      label "<b>Executive Director Information</b>", :custom_class => 'c_q55'
      
      q_55 "Executive Director First Name"
      a_55 :string

      q_56 "Executive Director Last Name", :custom_class => 'c_q56'
      a_56 :string 
      
      q_57 "Executive Director Email Address", :custom_class => 'c_q57'
      a_57 :string
 
      
      label "<br/><b>Electronic Signature</b><br/>"
   
      q_58 "By checking this box:<br/>", :pick => :any
      a_58 "I hereby indicate the information contained in this questionnaire is true and 
            correct to the best of my knowledge.", :custom_class => 'c_q58'
            
      label "<br/>"
    
      q_59 "By typing my name in the following space, I certify that I am authorized to submit this questionnaire. I further
            certify that this questionnaire is submitted with full knowledge and consent of my agency's Executive Director or other 
            governing body.<br/><br/>", :custom_class => 'c_q59'
      a_59 :string
      
      label "<br/>After review, the Monitoring Committee will review your completed questionnaire. The Monitoring Committee may 
             contact you if they have any questions or require more information.<br/><br/>
             Thank you, and feel free to contact {{recipient_email_address}} with any additional questions."

  end
  
end