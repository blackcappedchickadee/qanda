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
     
     audit_agency_information_section(survey_section_agency_information.id)
   end

   def get_program_information_section_values
     #page 2 values
     survey_section_program_information = SurveySection.find_by_data_export_identifier_and_survey_id("program_information", @survey_id)
     @data_program_info = get_response_with_only_one_value("data_program_info", @response_set_id, survey_section_program_information)
     @self_suff = get_response_with_only_one_value("self_suff", @response_set_id, survey_section_program_information)
     @program_verif_proc = get_response_with_only_one_value("program_verif_proc", @response_set_id, survey_section_program_information)
     @program_renewal_budget_pct = get_response_with_only_one_value("program_renewal_budget_pct", @response_set_id, survey_section_program_information)
     
     audit_program_information_section(survey_section_program_information.id)
   end

   def get_hmis_information_section_values
     #page 3 values
     survey_section_hmis_information = SurveySection.find_by_data_export_identifier_and_survey_id("hmis_participation", @survey_id)
     @participating_maine_hmis = get_response_with_only_one_value("your_project_participating_maine_hmis", @response_set_id, survey_section_hmis_information)
     @attachment_info_ude = get_attachment_info_ude(@mcoc_renewal_id)
     @letter_grade_ude = get_response_with_only_one_value("letter_grade_ude", @response_set_id, survey_section_hmis_information)
     @letter_grade_dkr = get_response_with_only_one_value("letter_grade_dkr", @response_set_id, survey_section_hmis_information)
     
     audit_hmis_information_section(survey_section_hmis_information.id)
     
   end

   def get_families_youth_section_values
     #page 4 values
     survey_section_families_youth = SurveySection.find_by_data_export_identifier_and_survey_id("families_youth", @survey_id)
     @project_work_with_families_youth = get_response_with_only_one_value("project_work_with_families_youth", @response_set_id, survey_section_families_youth)
     @and_form_process_document_this = get_response_with_only_one_value("and_form_process_document_this", @response_set_id, survey_section_families_youth)
     @applicable_prior_question_please_explain = get_response_with_only_one_value("applicable_prior_question_please_explain", @response_set_id, survey_section_families_youth) 
   
     audit_families_youth_section(survey_section_families_youth.id)
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
     
     audit_hud_section(survey_section_hud_continuum_goals.id)  
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
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "Fire Marshall Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_fire_marshall.nil?
           fire_marshall_col_3 = pass_fail_fire_marshall
         else
           fire_marshall_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "Fire Marshall Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_fire_marshall == "Not Applicable"
             if !fire_marshall_not_applicable_reason.nil?
               if fire_marshall_not_applicable_reason.length > 0
                 fire_marshall_col_1 << " - #{fire_marshall_not_applicable_reason}"
               else
                 fire_marshall_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "Fire Marshall Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               fire_marshall_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "Fire Marshall Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       fire_marshall_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "Fire Marshall Site Visit", @not_provided_text)
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
            write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "DHHS Licensing Site Visit - Date of Last Inspection", @not_provided_text)
          end
          if !pass_fail_dhhs.nil?
            dhhs_col_3 = pass_fail_dhhs
          else
            dhhs_col_3 = "#{@not_provided_text}"
            write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "DHHS Licensing Site Visit - Pass or Fail", @not_provided_text)
          end
        else
          #begin 7.11.2012
          if site_visit_dhhs == "Not Applicable"
              if !dhhs_not_applicable_reason.nil?
                if dhhs_not_applicable_reason.length > 0
                  dhhs_col_1 << " - #{dhhs_not_applicable_reason}"
                else
                  dhhs_col_1 << " - Reason: #{@not_provided_text}"
                  write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "DHHS Licensing Site Visit - Not Applicable Reason", @not_provided_text)
                end
              else
                dhhs_col_1 << " - Reason: #{@not_provided_text}"
                write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "DHHS Licensing Site Visit - Not Applicable Reason", @not_provided_text)
              end
          end
          #end 7.11.2012
        end #yes - site visit
      else
        dhhs_col_1 = "#{@not_provided_text}"
        write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "DHHS Licensing Site Visit", @not_provided_text)
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
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "MaineHousing Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_msha.nil?
           msha_col_3 = pass_fail_msha
         else
           msha_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "MaineHousing Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_msha == "Not Applicable"
             if !msha_not_applicable_reason.nil?
               if msha_not_applicable_reason.length > 0
                 msha_col_1 << " - #{msha_not_applicable_reason}"
               else
                 msha_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "MaineHousing Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               msha_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "MaineHousing Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       msha_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "MaineHousing Site Visit", @not_provided_text)
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
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "CARF Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_carf.nil?
           carf_col_3 = pass_fail_carf
         else
           carf_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "CARF Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_carf == "Not Applicable"
             if !carf_not_applicable_reason.nil?
               if carf_not_applicable_reason.length > 0
                 carf_col_1 << " - #{carf_not_applicable_reason}"
               else
                 carf_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "CARF Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               carf_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "CARF Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       carf_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "CARF Site Visit", @not_provided_text)
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
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HUD Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_hud.nil?
           hud_col_3 = pass_fail_hud
         else
           hud_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HUD Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_hud == "Not Applicable"
             if !hud_not_applicable_reason.nil?
               if hud_not_applicable_reason.length > 0
                 hud_col_1 << " - #{hud_not_applicable_reason}"
               else
                 hud_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HUD Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               hud_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HUD Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       hud_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HUD Site Visit", @not_provided_text)
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
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HQS Site Visit - Date of Last Inspection", @not_provided_text)
         end
         if !pass_fail_hqs.nil?
           hqs_col_3 = pass_fail_hqs
         else
           hqs_col_3 = "#{@not_provided_text}"
           write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HQS Site Visit - Pass or Fail", @not_provided_text)
         end
       else
         #begin 7.11.2012
         if site_visit_hqs == "Not Applicable"
             if !hqs_not_applicable_reason.nil?
               if hqs_not_applicable_reason.length > 0
                 hqs_col_1 << " - #{hqs_not_applicable_reason}"
               else
                 hqs_col_1 << " - Reason: #{@not_provided_text}"
                 write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HQS Site Visit - Not Applicable Reason", @not_provided_text)
               end
             else
               hqs_col_1 << " - Reason: #{@not_provided_text}"
               write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HQS Site Visit - Not Applicable Reason", @not_provided_text)
             end
         end
         #end 7.11.2012
       end #yes - site visit
     else
       hqs_col_1 = "#{@not_provided_text}"
       write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "HQS Site Visit", @not_provided_text)
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
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "#{@name_other1} Site Visit - Date of Last Inspection", @not_provided_text)
           end
           if !pass_fail_other1.nil?
             other1_col_3 = pass_fail_other1
           else
             other1_col_3 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "#{@name_other1} Site Visit - Pass or Fail", @not_provided_text)
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
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "#{@name_other2} Site Visit - Date of Last Inspection", @not_provided_text)
           end
           if !pass_fail_other2.nil?
             other2_col_3 = pass_fail_other2
           else
             other2_col_3 = "#{@not_provided_text}"
             write_audit(@user_id, @mcoc_renewal_id, survey_section_physical_plant.id, "#{@name_other2} Site Visit - Pass or Fail", @not_provided_text)
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
     
     audit_final_section(survey_section_finish.id)
   end
   
   def audit_agency_information_section(section_id)
      if @agency_name.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Agency Name", @not_provided_text)
      end

      if @program_name.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Program Name", @not_provided_text)
      end

      if @project_address.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Project Address(es)", @not_provided_text)
      end

      if @contact_person.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Contact Person", @not_provided_text)
      end
    
      if @phone_number.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Phone Number", @not_provided_text)
      end

      if @e_mail_address.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "E-mail Address", @not_provided_text)
      end 

  end
   

  def audit_program_information_section(section_id)

      if @data_program_info.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Program Information Description", @not_provided_text)
      end
      
      if @self_suff.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Access to Mainstream resources, income and ability to live independently Descriptions", @not_provided_text)
      end
      
      if @program_verif_proc.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Verification Process Description", @not_provided_text)
      end
      
      if @program_renewal_budget_pct.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "McKinney-Vento Renewal Percentage Description", @not_provided_text)
      end
   end
   
   
   def audit_hmis_information_section(section_id)

      if @participating_maine_hmis.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Maine HMIS Participation", @not_provided_text)
      else
        var_hmis_particp = @participating_maine_hmis
      end
      if var_hmis_particp == "Yes"

        if @attachment_info_ude.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "UDE Data Completeness Report", @not_provided_text)
        end

        if @letter_grade_ude.nil?
           write_audit(@user_id, @mcoc_renewal_id, section_id, "UDE Data Completeness letter grade", @not_provided_text)
        end
        if @letter_grade_dkr.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "DKR letter grade", @not_provided_text)
        end
        
      end
   end
   
   def audit_families_youth_section(section_id)
      var_project_work_with_families_youth = ""
      if @project_work_with_families_youth.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Does your project work with Families or Youth?", @not_provided_text)
      else
        var_project_work_with_families_youth = @project_work_with_families_youth
      end
      if var_project_work_with_families_youth == "Yes"
        var_and_form_process_document_this = ""
        if @and_form_process_document_this.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Do you have a policy in place, staff assigned to inform clients of their rights under the McKinney-Vento Homeless Education Assistance Act, and a form or process to document this?", @not_provided_text)
        else
          var_and_form_process_document_this = @and_form_process_document_this
        end
        if var_and_form_process_document_this == "No or Not Applicable"
          if @applicable_prior_question_please_explain.nil?
            write_audit(@user_id, @mcoc_renewal_id, section_id, "Since you have indicated 'No or Not Applicable' to the prior question (policy in place, staff assigned to inform clients, form or process to document this), please explain.", @not_provided_text)
          end
        end
      end
   end
   
   def audit_hud_section(section_id)
        
      if @attachment_info_apr.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "APR Report", @not_provided_text)
      else
        if @attachment_info_apr == "text"
          write_audit(@user_id, @mcoc_renewal_id, section_id, "APR Report", @not_provided_text)
        end
      end
      var_reported_your_most_recent_apr = 0
      if @reported_your_most_recent_apr.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Average Daily Bed Utilization reported in your most recent APR", @not_provided_text)
      else
        var_reported_your_most_recent_apr = @reported_your_most_recent_apr
      end

      if var_reported_your_most_recent_apr.to_f < 85 && @if_below_85_please_explain.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Average Daily Bed Utilization Utilization below 85%, please explain", @not_provided_text)
      end

      if @employed_at_program_at_exit.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "What percentage of your tenants were employed at program at exit?", @not_provided_text)
      else
        var_employed_at_program_at_exit = @employed_at_program_at_exit
      end

      if var_employed_at_program_at_exit.to_f < 20 && @less_than_20_please_explain.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Percentage of your tenants employed at program at exit below 20%, please explain.", @not_provided_text)
      end


      var_project_involve_transitional_housing_projects = ""
      if @project_involve_transitional_housing_projects.nil?
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Does your project involve Transitional Housing Projects?", @not_provided_text)
      else
        var_project_involve_transitional_housing_projects = @project_involve_transitional_housing_projects
      end
      var_moved_from_transitional_permanent_housing = 0
      if var_project_involve_transitional_housing_projects == "Yes"
        if @moved_from_transitional_permanent_housing.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "What percentage of tenants moved from transitional to permanent housing?", @not_provided_text)
        else
          var_moved_from_transitional_permanent_housing = @moved_from_transitional_permanent_housing
        end

        if var_moved_from_transitional_permanent_housing.to_f < 65 && @if_below_65_please_explain.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Percentage of tenants moved from transitional to permanent housing below 65%, please explain.", @not_provided_text)
        end
      end #transitional housing = yes block
      
      
      var_involve_permanent_supportive_housing_projects = ""
      if @involve_permanent_supportive_housing_projects.nil? 
        write_audit(@user_id, @mcoc_renewal_id, section_id, "Does your project involve Permanent Supportive Housing Projects?", @not_provided_text)
      else
        var_involve_permanent_supportive_housing_projects = @involve_permanent_supportive_housing_projects
      end
      
      if var_involve_permanent_supportive_housing_projects == "Yes"
        var_permanent_housing_over_6_months = 0
        if @permanent_housing_over_6_months.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "What percentage of tenants have been in permanent housing over 6 months?", @not_provided_text)
        else
          var_permanent_housing_over_6_months = @permanent_housing_over_6_months
        end
        if var_permanent_housing_over_6_months.to_f < 77 && @if_below_77_please_explain.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Percentage of tenants have been in permanent housing over 6 months below 77%, please explain.", @not_provided_text)
        end
      end #supportive housing = yes block
    end
    
    def audit_final_section(section_id)

       if @preparer_first_name.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Preparer First Name", @not_provided_text)
       end

       if @preparer_last_name.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Preparer Last Name", @not_provided_text)
       end

       if @preparer_title.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Preparer Title", @not_provided_text)
       end

       if @execdir_first_name.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Executive Director First Name", @not_provided_text)
       end
       if @execdir_last_name.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Executive Director Last Name", @not_provided_text)
       end

       if @execdir_email_address.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "Executive Director Email Address", @not_provided_text)
       end
       if @elect_sig_checkval.length == 0
          write_audit(@user_id, @mcoc_renewal_id, section_id, "I hereby indicate the information contained in this questionnaire is true and correct to the best of my knowledge", @not_provided_text)
       end

       if @elect_sig_name.nil?
          write_audit(@user_id, @mcoc_renewal_id, section_id, "By typing my name in the following space, I certify that I am authorized to submit this questionnaire. I further certify that this questionnaire is submitted with full knowledge and consent of my agency's Executive Director or other governing body.", @not_provided_text)
       end

    end
    
    
    
  private
  
    def obtain_section_name(section_id) 
      @tmp_section_name = SurveySection.find(section_id)
      return @tmp_section_name.title
    end
    
    def write_audit(user_id, mcoc_renewal_id, section_id, audit_key, audit_value) 
        saved = false
        @section_name = obtain_section_name(section_id)
        @audit_record = McocRenewalsDataQualityAudit.create(:user_id => user_id, :mcoc_renewal_id => mcoc_renewal_id, 
            :section_id => section_id, :audit_key => audit_key, :audit_value => audit_value, :section_name => @section_name)
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