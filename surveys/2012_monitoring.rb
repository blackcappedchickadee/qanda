survey "2012 Monitoring and Evaluation" do
  section "Agency Information" do
      # A label is a question that accepts no answers
      label "<b>Instructions:</b>  Please complete this form if your agency intends to apply for Renewal McKinney Vento Funding through the Maine Continuum of Care in 2012. 
            All responses and appropriate attachments must be received electronically by [FIRST LAST] no later than [DUE_DATE_2012]. 
            Please send all materials to: [EMAIL_ADDRESS]. A separate survey must be completed for each program/project seeking renewal."
      
      # Surveys, sections, questions, groups, and answers all take the following reference arguments
      # :reference_identifier   # usually from paper
      # :data_export_identifier # data export
      # :common_namespace       # maping to a common vocab
      # :common_identifier      # maping to a common vocab
      q_1 "Agency Information", :reference_identifier => "agency_info", :data_export_identifier => "agency_info", :common_namespace => "Agency Information", :common_identifier => "Agency Information"
      a_1 "Agency Name", :string
      a_1 "Program Name", :string
      a_1 "Project Address(es)", :text
      a_1 "Contact Person", :string
      a_1 "Phone Number", :string
      a_1 "E-mail Address", :string  
  end #section Agency Information 
  section "Program Information" do
      # A label is a question that accepts no answers
      label "<b>Please answer thgrantee_namee following questions</b><br/>"
      q_2 "Provide a brief program summary", :reference_identifier => "program_info", :data_export_identifier => "program_info", :common_namespace => "Program Information", :common_identifier => "Program Information"
      a_2 "Type of Program", :text
      a_2 "Population Served", :text
      a_2 "Specific services or operations for which the McKinney-Vento funding will be used", :text
      
      q_3 "Self Sufficiency – Please describe how project participants will be assisted to access Mainstream resources, increase incomes and maximize their ability to live independently?", :reference_identifier => "self_suff", :data_export_identifier => "self_suff", :common_namespace => "Self Sufficiency", :common_identifier => "Self Sufficiency"
      a_3 :text
      
      q_4 "Projects are required to verify homeless and chronic homeless status during intake. Please describe your verification process and attach a copy of your agency’s Homeless Status verification form.", :reference_identifier => "program_verif_proc", :data_export_identifier => "program_verif_proc", :common_namespace => "Program Verification Process", :common_identifier => "Program Verification Process"
      a_4 :text
  end #section Program Information 
  section "Program Funding" do
      label "Please list sources, services and dollar amounts.<i>(Please note - the figures listed here should correspond to the Match that appears in lines 15 and or 34 in the budgets listed below this section. We do not need all 'Leverage' information, though projects should continue to document leverage for their own records).</i>"
      # Repeaters allow multiple responses to a question or set of questions
      repeater "Please list sources, services, and dollar amounts" do
      q_5a "Cash or in-kind", :pick => :one, :display_type => :dropdown
      a_5a "Cash"
      a_5a "In-kind"
      q_5b "Type/Purpose of Contribution"
      a_5b :string
      q_5c "Source of Contribution"
      a_5c :string
      q_5d "Identify Source", :pick => :one, :display_type => :dropdown
      a_5d "Government"
      a_5d "Private"
      q_5e "Date of Written Committment"
      a_5e :date
      q_5f "Value of Written Committment"
      a_5f "$", :string
     end
     
     label "Budget of <b>Operating Costs</b>"
     group "Maintenance/Repair", :display_type => :inline do
      q_6a "Description and Details"
      a_6a "Description", :string
      q_6b "SHP Request 1 Year"
      a_6b "$", :string
      end
      
      group "Staff", :display_type => :inline do
      q_7a "Description and Details"
      a_7a "Description", :string
      q_7b "SHP Request 1 Year"
      a_7b "$", :string 
      end
      
      group "Utilities", :display_type => :inline do
      q_8a "Description and Details"
      a_8a "Description", :string
      q_8b "SHP Request 1 Year"
      a_8b "$", :string 
      end
      
      group "Equipment (lease/buy)", :display_type => :inline do
      q_9a "Description and Details"
      a_9a "Description", :string
      q_9b "SHP Request 1 Year"
      a_9b "$", :string 
      end
      
      group "Supplies", :display_type => :inline do
      q_10a "Description and Details"
      a_10a "Description", :string
      q_10b "SHP Request 1 Year"
      a_10b "$", :string 
      end
      
      group "Insurance", :display_type => :inline do
      q_11a "Description and Details"
      a_11a "Description", :string
      q_11b "SHP Request 1 Year"
      a_11b "$", :string 
      end
      
      group "Furnishings", :display_type => :inline do
      q_12a "Description and Details"
      a_12a "Description", :string
      q_12b "SHP Request 1 Year"
      a_12b "$", :string 
      end
      
      group "Relocation", :display_type => :inline do
      q_13a "Description and Details"
      a_13a "Description", :string
      q_13b "SHP Request 1 Year"
      a_13b "$", :string 
      end
      
      group "Other Operating Activity", :display_type => :inline do  
      q_14a "Description and Details"
      a_14a "Description", :string
      q_14b "SHP Request 1 Year"
      a_14b "$", :string 
      end
      
      group "Other Operating Activity", :display_type => :inline do  
      q_15a "Description and Details"
      a_15a "Description", :string
      q_15b "SHP Request 1 Year"
      a_15b "$", :string 
      end
      
      group "Other Operating Activity", :display_type => :inline do  
      q_16a "Description and Details"
      a_16a "Description", :string
      q_16b "SHP Request 1 Year"
      a_16b "$", :string 
      end
      
      group "Other Operating Activity", :display_type => :inline do  
      q_17a "Description and Details"
      a_17a "Description", :string
      q_17b "SHP Request 1 Year"
      a_17b "$", :string 
      end

      group "Total SHP Operating Dollars Request", :display_type => :inline do  
      q_18a "Total of lines 2 - 13"
      a_18a "$", :string
      end
      
      group "Total cash match to be spent on SHP eligible Operations activities", :display_type => :inline do  
      q_19a "Total"
      a_19a "$", :string
      end
      
      group "Total SHP Operating Budget", :display_type => :inline do  
      q_19a "Total"
      a_19a "$", :string
      end
      
      group "Any other Resources (cash and in-kind) used for Operations Activities", :display_type => :inline do  
      q_19a "Total of any other resources"
      a_19a "$", :string
      end
      
      label "Budget of <b>Supportive Services Costs</b>"
      group "Outreach", :display_type => :inline do  
      q_20a "Description and Details"
      a_20a "Description", :string
      q_20b "SHP Request 1 Year"
      a_20b "$", :string 
      end
      
      group "Case Management", :display_type => :inline do  
      q_21a "Description and Details"
      a_21a "Description", :string
      q_21b "SHP Request 1 Year"
      a_21b "$", :string 
      end
      
      group "Life Skills (outside of case management)", :display_type => :inline do  
      q_22a "Description and Details"
      a_22a "Description", :string
      q_22b "SHP Request 1 Year"
      a_22b "$", :string 
      end
      
      group "Alcohol and Drug Abuse Services", :display_type => :inline do  
      q_23a "Description and Details"
      a_23a "Description", :string
      q_23b "SHP Request 1 Year"
      a_23b "$", :string 
      end
      
      group "Mental Health and Counseling Services", :display_type => :inline do  
      q_24a "Description and Details"
      a_24a "Description", :string
      q_24b "SHP Request 1 Year"
      a_24b "$", :string 
      end
      
      group "HIV/AIDS Services", :display_type => :inline do  
      q_25a "Description and Details"
      a_25a "Description", :string
      q_25b "SHP Request 1 Year"
      a_25b "$", :string 
      end
      
      group "Health Related and Home Health Services", :display_type => :inline do  
      q_26a "Description and Details"
      a_26a "Description", :string
      q_26b "SHP Request 1 Year"
      a_26b "$", :string 
      end
      
      group "Education and Instruction", :display_type => :inline do  
      q_27a "Description and Details"
      a_27a "Description", :string
      q_27b "SHP Request 1 Year"
      a_27b "$", :string 
      end
      
      group "Employment Services", :display_type => :inline do  
      q_28a "Description and Details"
      a_28a "Description", :string
      q_28b "SHP Request 1 Year"
      a_28b "$", :string 
      end
      
      group "Child Care", :display_type => :inline do  
      q_29a "Description and Details"
      a_29a "Description", :string
      q_29b "SHP Request 1 Year"
      a_29b "$", :string 
      end
      
      group "Transportation", :display_type => :inline do  
      q_30a "Description and Details"
      a_30a "Description", :string
      q_30b "SHP Request 1 Year"
      a_30b "$", :string 
      end
      
      group "Transitional Living Services", :display_type => :inline do  
      q_31a "Description and Details"
      a_31a "Description", :string
      q_31b "SHP Request 1 Year"
      a_31b "$", :string 
      end
      
      group "Other (must specify)", :display_type => :inline do  
      q_32a "Description and Details"
      a_32a "Description", :string
      q_32b "SHP Request 1 Year"
      a_32b "$", :string 
      end
  
      group "Other (must specify)", :display_type => :inline do  
      q_33a "Description and Details"
      a_33a "Description", :string
      q_33b "SHP Request 1 Year"
      a_33b "$", :string 
      end
      
      group "Other (must specify)", :display_type => :inline do  
      q_34a "Description and Details"
      a_34a "Description", :string
      q_34b "SHP Request 1 Year"
      a_34b "$", :string 
      end

      group "Total SHP Service dollars requested", :display_type => :inline do  
      q_35a "Total of lines 18 - 32"
      a_35a "$", :string
      end
      
      group "Total cash match to be spent on SHP eligible supportive service activities", :display_type => :inline do  
      q_36a "Total"
      a_36a "$", :string
      end
      
      group "Total SHP Supportive Services Budget", :display_type => :inline do  
      q_37a "Total"
      a_36a "$", :string
      end
      
      group "Any other Resources (cash and in-kind) used for Supportive Services Activities", :display_type => :inline do  
      q_38a "Total of any other resources"
      a_38a "$", :string
      end
  end #section Program Funding
  
  section "HMIS Participation" do
      q_39 "Is your project participating in the Maine HMIS (Homeless Management Information System)?", :pick => :one
      a_y "Yes"
      a_n "No"

      q_40 "Please follow this link to view a video on the mainehmis.org website that will explain how to run the
            'UDE Data Completeness Report', and how to make any corrections or updates needed to improve your data completeness.
            <br/><br/>This report and its grading system are based upon what is required of Emergency Shelters receiving 2012 ESG/State 
            Homeless funds, but the report will also work for Transitional and Permanent Supportive Housing Programs.
            <br/><br/>Run a report for each facility up for renewal this year and <b>return an electronic copy of the report.
            Please run the UDE Data Completeness Report for the same time fram as your APR Operating Year.</b> 
            <br/><br/><a href='http://mainehmis.org/04/15/ude-data-completeness-report-video/'>2011 Video for running the UDE Data Completeness Report</a><br/><br/>Have you viewed the video?", :pick => :one
      a_y "Yes"
      a_n "No"
      dependency :rule => "A"
      condition_A :q_39, "==", :a_y
      
  end #section HMIS
  
  section "Families or Youth" do
      q_41 "Does your project work with Families or Youth?", :pick => :one
      a_y "Yes"
      a_n "No"
    
      q_42 "Do you have a policy in place, and staff assigned to inform
            clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form  or 
            process to document this?", :pick => :one
      a_y "Yes"
      a_n "No"
      dependency :rule => "B"
      condition_B :q_41, "==", :a_y
 
      q_43 "Please explain why not:"
      a_43 :text
      dependency :rule => "C"
      condition_C :q_42, "==", :a_n
      
  end #section Families or Youth
  
  section "HUD Continuum Goals" do
      label "The next few questions are based on Continuum Coals set by HUD and subject to change once the 2012 NOFA is released.
           Please use the figures reported in your <u>most recent</u> Annual Progress Report (APR) submitted to HUD and 
           <b>return an electronic copy of that APR</b>."
           
      q_44 "What was your Occupance Rate reported in your most recent APR?"
      a_44 "|% (APR question 3.c)", :string
      
      q_45 "For that some time rame (your APR Operating Year), what was your Annual Occupancy Rate?"
      a_45 "|%", :string
      
      q_46 "If either of these Rates are below 85%, please explain:"
      a_46 :text
      
      q_47 "What percentage of your tenants were employed at program at exit?"
      a_47 "|% (APR question 11.D.h)", :string
      
      q_48 "If less than 20%, please explain:"
      a_48 :text
      
      q_49 "Does your project involve Transitional Housing Projects?", :pick => :one
      a_y "Yes"
      a_n "No"
      
      q_50 "What percentage of tenants moved from transitional to permanent housing?"
      a_50 "|% (APR question 14)", :string
      dependency :rule => "D"
      condition_D :q_49, "==", :a_y
      
      q_51 "If below 65%, please explain:"
      a_51 :text
      dependency :rule => "D"
      condition_D :q_49, "==", :a_y
      
      q_52 "Does your project involve Permanent Supportive Housing Projects?", :pick => :one
      a_y "Yes"
      a_n "No"
      
      q_53 "What percentage of tenants have been in permanent housing over 6 months?"
      a_53 "|% (APR questions 12a + 12b)", :string
      dependency :rule => "E"
      condition_E :q_52, "==", :a_y
      
      q_54 "If below 77%, please explain:"
      a_54 :text
      dependency :rule => "E"
      condition_E :q_52, "==", :a_y
        
  end #section HUD Continuum Goals
  
  section "Physical Plant" do
      label "Please indicate if any of the agencies below conduct site visits for this program. If so, please
            list the date of last inspection and status of that inspection. If there are any unresolved 
            findings or other issues, please explain briefly how they are - or will be resolved - and attach
            relevant documentation."

      group "Fire Marshall", :display_type => :inline do  
        q_55 "Site visit?", :pick => :one, :display_type => :inline
          a_55_y "Yes"
          a_55_n "No"
        q_56 "Date of last inspection", :display_type => :inline
        a_56 :date
        q_57 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_57_y "Pass"
        a_57_n "Fail"
      end
      
      group "DHHS Licensing", :display_type => :inline do  
        q_58 "Site visit?", :pick => :one, :display_type => :inline
          a_58_y "Yes"
          a_58_n "No"
        q_59 "Date of last inspection", :display_type => :inline
        a_59 :date
        q_60 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_60_y "Pass"
        a_60_n "Fail"
      end
      
      group "MaineHousing", :display_type => :inline do  
        q_61 "Site visit?", :pick => :one, :display_type => :inline
          a_61_y "Yes"
          a_61_n "No"
        q_62 "Date of last inspection", :display_type => :inline
        a_62 :date
        q_63 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_63_y "Pass"
        a_63_n "Fail"
      end
      
      group "CARF", :display_type => :inline do  
        q_64 "Site visit?", :pick => :one, :display_type => :inline
          a_64_y "Yes"
          a_64_n "No"
        q_65 "Date of last inspection", :display_type => :inline
        a_65 :date
        q_66 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_66_y "Pass"
        a_66_n "Fail"
      end
      
      group "HUD", :display_type => :inline do  
        q_67 "Site visit?", :pick => :one, :display_type => :inline
          a_67_y "Yes"
          a_67_n "No"
        q_68 "Date of last inspection", :display_type => :inline
        a_68 :date
        q_69 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_69_y "Pass"
        a_69_n "Fail"
      end
      
      group "HQS", :display_type => :inline do  
        q_70 "Site visit?", :pick => :one, :display_type => :inline
          a_70_y "Yes"
          a_70_n "No"
        q_71 "Date of last inspection", :display_type => :inline
        a_71 :date
        q_72 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_72_y "Pass"
        a_72_n "Fail"
      end
      
      group "Other agency", :display_type => :inline do  
        q_73 "Name", :display_type => :inline
        a_73 :string
        q_74 "Site visit?", :pick => :one, :display_type => :inline
          a_74_y "Yes"
          a_74_n "No"
        q_75 "Date of last inspection", :display_type => :inline
        a_75 :date
        q_76 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_76_y "Pass"
        a_76_n "Fail"
      end
      
      group "Other agency", :display_type => :inline do  
        q_77 "Name", :display_type => :inline
        a_77 :string
        q_78 "Site visit?", :pick => :one, :display_type => :inline
          a_78_y "Yes"
          a_78_n "No"
        q_79 "Date of last inspection", :display_type => :inline
        a_79 :date
        q_80 "Pass or Fail?", :pick => :one, :display_type => :inline
        a_80_y "Pass"
        a_80_n "Fail"
      end
    
      q_81 "Physical plant narrative (if necessary)"
      a_81 :text

  end
  
  section "Finish" do
      label "Please provide the following information to complete the Monitoring and Evaluation questionnaire:"
      label "<i>All information submitted is true and accurate to the best of my knowledge.</i>"
      
      group "Prepared by:", :display_type => :inline do  
        q_82 "First Name", :display_type => :inline
        a_82 :string

        q_83 "Last Name", :display_type => :inline
        a_83 :string
        
        q_84 "Title", :display_type => :inline
        a_84 :string
  
        label "</br>(If different from agency/program contact information):"
        q_85 "Email address", :display_type => :inline
        a_85 :string

        q_86 "Phone number", :display_type => :inline
        a_86 :string
      end
    
      label "[ELECTRONIC_SIGNATURE]? Legal ramifications? Do we offer a one-page downloadable PDF that is still
      filled out to act as legal signatures on file?"
      
      label "After review, the Monitoring Committee will contact you if they have any questions or require more information.<br/><br/>
         Thank you, and feel free to contact [CONTACT_NAME] with any additional questions."
         
    
      
  end
  
end