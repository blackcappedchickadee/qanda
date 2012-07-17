module Questionnaire
  module Data
    
    @mcoc_renewal_id = 0
    @response_set_id = 0
    @response_set_code = 0
    @grantee_name = ""
    @project_name = "" 
    @doc_name = 0
    
    def configure(user_id, mcoc_renewal_id, response_set_code, grantee_name, project_name, doc_name)
      
      audit_destroy_all
      
      @user_id = user_id
      @mcoc_renewal_id = mcoc_renewal_id
      @response_set_code = response_set_code
      @grantee_name = grantee_name
      @project_name = project_name

      response_set = ResponseSet.find_by_access_code(response_set_code)
      @response_set_id = response_set.id
      @survey_id = response_set.survey_id
      
      @not_provided_text = "<b><color rgb='ff0000'>Not Provided</color></b>"
      

    end
    

    def get_agency_information_section_values
     #page 1 values 
     survey_section_agency_information = SurveySection.find_by_data_export_identifier_and_survey_id("agency_information", @survey_id)
     @agency_name = get_agency_information_response("agency_name", @response_set_id, survey_section_agency_information)
     @program_name = get_agency_information_response("program_name", @response_set_id, survey_section_agency_information)
     @project_address = get_agency_information_response("project_address", @response_set_id, survey_section_agency_information)
     @contact_person = get_agency_information_response("contact_person", @response_set_id, survey_section_agency_information)
     @phone_number = get_agency_information_response("phone_number", @response_set_id, survey_section_agency_information)
     @e_mail_address = get_agency_information_response("e_mail_address", @response_set_id, survey_section_agency_information) 
   end

   def get_program_information_section_values
     #page 2 values
     survey_section_program_information = SurveySection.find_by_data_export_identifier_and_survey_id("program_information", @survey_id)
     @data_program_info = get_response_with_only_one_value("data_program_info", @response_set_id, survey_section_program_information)
     @self_suff = get_response_with_only_one_value("self_suff", @response_set_id, survey_section_program_information)
     @program_verif_proc = get_response_with_only_one_value("program_verif_proc", @response_set_id, survey_section_program_information)
     @program_renewal_budget_pct = get_response_with_only_one_value("program_renewal_budget_pct", @response_set_id, survey_section_program_information)
   end

   def get_hmis_information_section_values
     #page 3 values
     survey_section_hmis_information = SurveySection.find_by_data_export_identifier_and_survey_id("hmis_participation", @survey_id)
     @participating_maine_hmis = get_response_with_only_one_value("your_project_participating_maine_hmis", @response_set_id, survey_section_hmis_information)
     @attachment_info_ude = get_attachment_info_ude(@mcoc_renewal_id)
     @letter_grade_ude = get_response_with_only_one_value("letter_grade_ude", @response_set_id, survey_section_hmis_information)
     @letter_grade_dkr = get_response_with_only_one_value("letter_grade_dkr", @response_set_id, survey_section_hmis_information)
   end

   def get_families_youth_section_values
     #page 4 values
     survey_section_families_youth = SurveySection.find_by_data_export_identifier_and_survey_id("families_youth", @survey_id)
     @project_work_with_families_youth = get_response_with_only_one_value("project_work_with_families_youth", @response_set_id, survey_section_families_youth)
     @and_form_process_document_this = get_response_with_only_one_value("and_form_process_document_this", @response_set_id, survey_section_families_youth)
     @applicable_prior_question_please_explain = get_response_with_only_one_value("applicable_prior_question_please_explain", @response_set_id, survey_section_families_youth) 
   end

   def get_hud_section_values
     #page 5 values
     survey_section_hud_continuum_goals = SurveySection.find_by_data_export_identifier_and_survey_id("hud_continuum_goals", @survey_id)
     @attachment_info_apr = get_attachment_info_apr(@mcoc_renewal_id)
     @reported_your_most_recent_apr = get_response_with_only_one_value("reported_your_most_recent_apr", @response_set_id, survey_section_hud_continuum_goals)
     @if_below_85_please_explain = get_response_with_only_one_value("if_below_85_please_explain", @response_set_id, survey_section_hud_continuum_goals)
     @employed_at_program_at_exit = get_response_with_only_one_value("employed_at_program_at_exit", @response_set_id, survey_section_hud_continuum_goals)
     @less_than_20_please_explain = get_response_with_only_one_value("less_than_20_please_explain", @response_set_id, survey_section_hud_continuum_goals)
     @project_involve_transitional_housing_projects = get_response_with_only_one_value("project_involve_transitional_housing_projects", @response_set_id, survey_section_hud_continuum_goals)
     @moved_from_transitional_permanent_housing = get_response_with_only_one_value("moved_from_transitional_permanent_housing", @response_set_id, survey_section_hud_continuum_goals)
     @if_below_65_please_explain = get_response_with_only_one_value("if_below_65_please_explain", @response_set_id, survey_section_hud_continuum_goals)
     @involve_permanent_supportive_housing_projects = get_response_with_only_one_value("involve_permanent_supportive_housing_projects", @response_set_id, survey_section_hud_continuum_goals)    
     @permanent_housing_over_6_months = get_response_with_only_one_value("permanent_housing_over_6_months", @response_set_id, survey_section_hud_continuum_goals)    
     @if_below_77_please_explain = get_response_with_only_one_value("if_below_77_please_explain", @response_set_id, survey_section_hud_continuum_goals)    
   end

   def get_physical_plant_section_values
     #page 6 values - physcial plant
     survey_section_physical_plant = SurveySection.find_by_data_export_identifier_and_survey_id("physical_plant", @survey_id)
     site_visit_fire_marshall = get_response_with_only_one_value("site_visit_fire_marshall", @response_set_id, survey_section_physical_plant)
     inspection_date_fire_marshall = get_response_with_only_one_value("inspection_date_fire_marshall", @response_set_id, survey_section_physical_plant)
     pass_fail_fire_marshall = get_response_with_only_one_value("pass_fail_fire_marshall", @response_set_id, survey_section_physical_plant)
     fire_marshall_not_applicable_reason = get_response_with_only_one_value("fire_marshall_not_applicable_reason", @response_set_id, survey_section_physical_plant)
     fire_marshall_col_1 = ""
     fire_marshall_col_2 = ""
     fire_marshall_col_3 = ""
     fire_marshall_col_4 = ""
     if !site_visit_fire_marshall.nil?
       fire_marshall_col_1 = site_visit_fire_marshall
       if site_visit_fire_marshall == "Yes"
         if !inspection_date_fire_marshall.nil?
           fire_marshall_col_2 = inspection_date_fire_marshall
         else
           fire_marshall_col_2 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "Fire Marshall Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_fire_marshall.nil?
           fire_marshall_col_3 = pass_fail_fire_marshall
         else
           fire_marshall_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "Fire Marshall Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_fire_marshall == "Not Applicable"
             if !fire_marshall_not_applicable_reason.nil?
               if fire_marshall_not_applicable_reason.length > 0
                 fire_marshall_col_1 << " - #{fire_marshall_not_applicable_reason}"
               else
                 fire_marshall_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "Fire Marshall Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               fire_marshall_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "Fire Marshall Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       fire_marshall_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "Fire Marshall Site Visit", @not_provided_text)
     end
     @data_fire_marshall = [[ fire_marshall_col_1, fire_marshall_col_2, fire_marshall_col_3]]

      site_visit_dhhs = get_response_with_only_one_value("site_visit_dhhs", @response_set_id, survey_section_physical_plant)
      inspection_date_dhhs = get_response_with_only_one_value("inspection_date_dhhs", @response_set_id, survey_section_physical_plant)
      pass_fail_dhhs = get_response_with_only_one_value("pass_fail_dhhs", @response_set_id, survey_section_physical_plant)
      dhhs_not_applicable_reason = get_response_with_only_one_value("dhhs_licensing_not_applicable_reason", @response_set_id, survey_section_physical_plant)
      dhhs_col_1 = ""
      dhhs_col_2 = ""
      dhhs_col_3 = ""
      dhhs_col_4 = ""
      if !site_visit_dhhs.nil?
        dhhs_col_1 = site_visit_dhhs
        if site_visit_dhhs == "Yes"
          if !inspection_date_dhhs.nil?
            dhhs_col_2 = inspection_date_dhhs
          else
            dhhs_col_2 = "#{@not_provided_text}"
            write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "DHHS Licensing Site Visit - Date of Last Inspection", @not_provided_text)
          end
          if !pass_fail_dhhs.nil?
            dhhs_col_3 = pass_fail_dhhs
          else
            dhhs_col_3 = "#{@not_provided_text}"
            write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "DHHS Licensing Site Visit - Pass or Fail", @not_provided_text)
          end
        else
          #begin 7.11.2012
          if site_visit_dhhs == "Not Applicable"
              if !dhhs_not_applicable_reason.nil?
                if dhhs_not_applicable_reason.length > 0
                  dhhs_col_1 << " - #{dhhs_not_applicable_reason}"
                else
                  dhhs_col_1 << " - Reason: #{@not_provided_text}"
                  write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "DHHS Licensing Site Visit - Not Applicable Reason", @not_provided_text)
                end
              else
                dhhs_col_1 << " - Reason: #{@not_provided_text}"
                write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "DHHS Licensing Site Visit - Not Applicable Reason", @not_provided_text)
              end
          end
          #end 7.11.2012
        end #yes - site visit
      else
        dhhs_col_1 = "#{@not_provided_text}"
        write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "DHHS Licensing Site Visit", @not_provided_text)
      end
      @data_dhhs = [[ dhhs_col_1, dhhs_col_2, dhhs_col_3]]

     site_visit_msha = get_response_with_only_one_value("site_visit_msha", @response_set_id, survey_section_physical_plant)
     inspection_date_msha = get_response_with_only_one_value("inspection_date_msha", @response_set_id, survey_section_physical_plant)
     pass_fail_msha = get_response_with_only_one_value("pass_fail_msha", @response_set_id, survey_section_physical_plant)
     msha_not_applicable_reason = get_response_with_only_one_value("mainehousing_not_applicable_reason", @response_set_id, survey_section_physical_plant)
     msha_col_1 = ""
     msha_col_2 = ""
     msha_col_3 = ""
     msha_col_4 = ""
     if !site_visit_msha.nil?
       msha_col_1 = site_visit_msha
       if site_visit_msha == "Yes"
         if !inspection_date_msha.nil?
           msha_col_2 = inspection_date_msha
         else
           msha_col_2 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "MaineHousing Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_msha.nil?
           msha_col_3 = pass_fail_msha
         else
           msha_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "MaineHousing Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_msha == "Not Applicable"
             if !msha_not_applicable_reason.nil?
               if msha_not_applicable_reason.length > 0
                 msha_col_1 << " - #{msha_not_applicable_reason}"
               else
                 msha_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "MaineHousing Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               msha_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "MaineHousing Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       msha_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "MaineHousing Site Visit", @not_provided_text)
     end
     @data_msha = [[ msha_col_1, msha_col_2, msha_col_3]]    

     site_visit_carf = get_response_with_only_one_value("site_visit_carf", @response_set_id, survey_section_physical_plant)
     inspection_date_carf = get_response_with_only_one_value("inspection_date_carf", @response_set_id, survey_section_physical_plant)
     pass_fail_carf = get_response_with_only_one_value("pass_or_fail_carf", @response_set_id, survey_section_physical_plant)
     carf_not_applicable_reason = get_response_with_only_one_value("carf_not_applicable_reason", @response_set_id, survey_section_physical_plant)
     carf_col_1 = ""
     carf_col_2 = ""
     carf_col_3 = ""
     carf_col_4 = ""
     if !site_visit_carf.nil?
       carf_col_1 = site_visit_carf
       if site_visit_carf == "Yes"
         if !inspection_date_carf.nil?
           carf_col_2 = inspection_date_carf
         else
           carf_col_2 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "CARF Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_carf.nil?
           carf_col_3 = pass_fail_carf
         else
           carf_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "CARF Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_carf == "Not Applicable"
             if !carf_not_applicable_reason.nil?
               if carf_not_applicable_reason.length > 0
                 carf_col_1 << " - #{carf_not_applicable_reason}"
               else
                 carf_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "CARF Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               carf_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "CARF Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       carf_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "CARF Site Visit", @not_provided_text)
     end
     @data_carf = [[ carf_col_1, carf_col_2, carf_col_3]]

     site_visit_hud = get_response_with_only_one_value("site_visit_hud", @response_set_id, survey_section_physical_plant)
     inspection_date_hud = get_response_with_only_one_value("inspection_date_hud", @response_set_id, survey_section_physical_plant)
     pass_fail_hud = get_response_with_only_one_value("pass_or_fail_hud", @response_set_id, survey_section_physical_plant)
     hud_not_applicable_reason = get_response_with_only_one_value("hud_not_applicable_reason", @response_set_id, survey_section_physical_plant)
     hud_col_1 = ""
     hud_col_2 = ""
     hud_col_3 = ""
     hud_col_4 = ""
     if !site_visit_hud.nil?
       hud_col_1 = site_visit_hud
       if site_visit_hud == "Yes"
         if !inspection_date_hud.nil?
           hud_col_2 = inspection_date_hud
         else
           hud_col_2 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HUD Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_hud.nil?
           hud_col_3 = pass_fail_hud
         else
           hud_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HUD Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_hud == "Not Applicable"
             if !hud_not_applicable_reason.nil?
               if hud_not_applicable_reason.length > 0
                 hud_col_1 << " - #{hud_not_applicable_reason}"
               else
                 hud_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HUD Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               hud_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HUD Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       hud_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HUD Site Visit", @not_provided_text)
     end
     @data_hud = [[ hud_col_1, hud_col_2, hud_col_3]]

     site_visit_hqs = get_response_with_only_one_value("site_visit_hqs", @response_set_id, survey_section_physical_plant)
     inspection_date_hqs = get_response_with_only_one_value("inspection_date_hqs", @response_set_id, survey_section_physical_plant)
     pass_fail_hqs = get_response_with_only_one_value("pass_or_fail_hqs", @response_set_id, survey_section_physical_plant)
     hqs_not_applicable_reason = get_response_with_only_one_value("hqs_not_applicable_reason", @response_set_id, survey_section_physical_plant)
     hqs_col_1 = ""
     hqs_col_2 = ""
     hqs_col_3 = ""
     hqs_col_4 = ""
     if !site_visit_hqs.nil?
       hqs_col_1 = site_visit_hqs
       if site_visit_hqs == "Yes"
         if !inspection_date_hqs.nil?
           hqs_col_2 = inspection_date_hqs
         else
           hqs_col_2 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HQS Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_hqs.nil?
           hqs_col_3 = pass_fail_hqs
         else
           hqs_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HQS Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_hqs == "Not Applicable"
             if !hqs_not_applicable_reason.nil?
               if hqs_not_applicable_reason.length > 0
                 hqs_col_1 << " - #{hqs_not_applicable_reason}"
               else
                 hqs_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HQS Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               hqs_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HQS Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       hqs_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "HQS Site Visit", @not_provided_text)
     end
     @data_hqs = [[ hqs_col_1, hqs_col_2, hqs_col_3 + " " + hqs_col_4]]

     @name_other1 = get_response_with_only_one_value("name_other1", @response_set_id, survey_section_physical_plant)
     site_visit_other1 = get_response_with_only_one_value("site_visit_other1", @response_set_id, survey_section_physical_plant)
     inspection_date_other1 = get_response_with_only_one_value("inspection_date_other1", @response_set_id, survey_section_physical_plant)
     pass_fail_other1 = get_response_with_only_one_value("pass_or_fail_other1", @response_set_id, survey_section_physical_plant)
     other1_col_1 = ""
     other1_col_2 = ""
     other1_col_3 = ""
     other1_col_4 = ""
     if !@name_other1.nil?
       other1_col_0 = @name_other1
       if !site_visit_other1.nil?
         other1_col_1 = site_visit_other1
         if site_visit_other1 == "Yes"
           if !inspection_date_other1.nil?
             other1_col_2 = inspection_date_other1
           else
             other1_col_2 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "#{@name_other1} Site Visit - Date of Last Inspection", @not_provided_text)
           end
           if !pass_fail_other1.nil?
             other1_col_3 = pass_fail_other1
           else
             other1_col_3 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "#{@name_other1} Site Visit - Pass or Fail", @not_provided_text)
           end
         end #yes - site visit
       end
     end
     @data_other1 = [[ other1_col_1, other1_col_2, other1_col_3]]

     @name_other2 = get_response_with_only_one_value("name_other2", @response_set_id, survey_section_physical_plant)
     site_visit_other2 = get_response_with_only_one_value("site_visit_other2", @response_set_id, survey_section_physical_plant)
     inspection_date_other2 = get_response_with_only_one_value("inspection_date_other2", @response_set_id, survey_section_physical_plant)
     pass_fail_other2 = get_response_with_only_one_value("pass_or_fail_other2", @response_set_id, survey_section_physical_plant)
     other2_col_1 = ""
     other2_col_2 = ""
     other2_col_3 = ""
     other2_col_4 = ""
     if !@name_other2.nil?
       other2_col_0 = @name_other2
       if !site_visit_other2.nil?
         other2_col_1 = site_visit_other2
         if site_visit_other2 == "Yes"
           if !inspection_date_other2.nil?
             other2_col_2 = inspection_date_other2
           else
             other2_col_2 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "#{@name_other2} Site Visit - Date of Last Inspection", @not_provided_text)
           end
           if !pass_fail_other2.nil?
             other2_col_3 = pass_fail_other2
           else
             other2_col_3 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant, "#{@name_other2} Site Visit - Pass or Fail", @not_provided_text)
           end
         end #yes - site visit
       end
     end
     @data_other2 = [[ other2_col_1, other2_col_2, other2_col_3]]
     @phys_plant_narrative = get_response_with_only_one_value("phys_plant_narrative", @response_set_id, survey_section_physical_plant)
     @attachment_info_other = get_attachment_other(@mcoc_renewal_id)
   end

   def final_section_values
     #page 7
     survey_section_finish = SurveySection.find_by_data_export_identifier_and_survey_id("finish", @survey_id)
     @preparer_first_name = get_response_with_only_one_value("preparer_first_name", @response_set_id, survey_section_finish)
     @preparer_last_name = get_response_with_only_one_value("preparer_last_name", @response_set_id, survey_section_finish)
     @preparer_title = get_response_with_only_one_value("preparer_title", @response_set_id, survey_section_finish)
     @preparer_email_address = get_response_with_only_one_value("preparer_email_address", @response_set_id, survey_section_finish)
     @preparer_phone_number = get_response_with_only_one_value("preparer_phone_number", @response_set_id, survey_section_finish)
     @execdir_first_name = get_response_with_only_one_value("execdir_first_name", @response_set_id, survey_section_finish)
     @execdir_last_name = get_response_with_only_one_value("execdir_last_name", @response_set_id, survey_section_finish)
     @execdir_email_address = get_response_with_only_one_value("execdir_email_address", @response_set_id, survey_section_finish)
     @elect_sig_checkval = get_response_with_only_one_value("elect_sig_checkval", @response_set_id, survey_section_finish)
     @elect_sig_name = get_response_with_only_one_value("elect_sig_name", @response_set_id, survey_section_finish)
   end

    
    
  private
    
    def write_audit(user_id, mcoc_renewal_id, section_id, audit_key, audit_value) 
        saved = false
        @audit_record = McocRenewalsDataQualityAudit.create(:user_id => user_id, :mcoc_renewal_id => mcoc_renewal_id, :section_id => section_id, :audit_key => audit_key, :audit_value => audit_value)
        saved &= @audit_record.save
    end
    
    def audit_destroy_all
       #cleanup any audit (missing data) information before we produce the PDF
       McocRenewalsDataQualityAudit.destroy_all(:mcoc_renewal_id => @mcoc_renewal_id)
    end

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
            when "answer" #yes/no values, and checkbox
              if data_export_identifier == "elect_sig_checkval"
                @retval = "Checked"
              else
                @retval = tmp_answer.short_text
              end
            when "date"
              @retval = tmp_response.datetime_value.strftime("%m/%d/%Y")
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
            when "date"
              @retval = tmp_response.datetime_value.strftime("%m/%d/%Y")
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

    def get_attachment_other(mcoc_renewal_id)
      tmp_mcoc_asset = McocAsset.find_all_by_mcoc_renewal_id(mcoc_renewal_id)
      tmp_str = ""
      if !tmp_mcoc_asset.nil?
        tmp_mcoc_asset.each do |asset|
          if !asset.supporting_doc_file_name.nil?
            tmp_str <<  "- #{asset.supporting_doc_file_name} \n"
          end
        end
        retval = tmp_str
      end
      return retval
    end

    
    
  end
end