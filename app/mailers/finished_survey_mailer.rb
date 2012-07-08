class FinishedSurveyMailer < ActionMailer::Base
  default :to => FinishedSurveyEmailList.all.map(&:email_address), 
          :from => ENV['GMAIL_USER_NAME']
  
  def send_finished_email(finished_survey)

    @finished_survey = finished_survey

    attachments[@finished_survey.questionnaire_file_name] = File.read(@finished_survey.questionnaire.path)

    mail(:subject => "Notification: A 2012 Monitoring Questionnaire for #{@finished_survey.grantee_name} - #{@finished_survey.project_name} has been posted to the Document Library.",
         :from => ENV['GMAIL_USER_NAME'])
  end
  
  def send_finished_questionnaire_to_recipients(finished_survey, access_code, survey_id)
    
    @finished_survey = finished_survey
    
    response_set = ResponseSet.find_by_access_code(access_code)
    response_set_id = response_set.id
    
    attachments[@finished_survey.questionnaire_file_name] = File.read(@finished_survey.questionnaire.path)
    
    survey_section_agency_information = SurveySection.find_by_data_export_identifier_and_survey_id("agency_information", survey_id)
    survey_section_finish = SurveySection.find_by_data_export_identifier_and_survey_id("finish", survey_id)

    @e_mail_address = get_agency_information_response("e_mail_address", response_set_id, survey_section_agency_information)
    @preparer_first_name = get_response_with_only_one_value("preparer_first_name", response_set_id, survey_section_finish)
    @preparer_last_name = get_response_with_only_one_value("preparer_last_name", response_set_id, survey_section_finish)
    @preparer_email_address = get_response_with_only_one_value("preparer_email_address", response_set_id, survey_section_finish)
    @execdir_email_address = get_response_with_only_one_value("execdir_email_address", response_set_id, survey_section_finish)
    
    @preparer_full_name = ""
    
    if !@preparer_first_name.nil?
      @preparer_full_name << @preparer_first_name
    end
    if !@preparer_last_name.nil?
      @preparer_full_name << @preparer_last_name
    end
    
    @email_list = ""
    @bcc_list = "No"

    @email_prep = ""
    @email_exec = ""
    
    if !@preparer_email_address.nil?
      @email_prep = @preparer_email_address
    else
      @email_prep = @e_mail_address
    end
    
    @email_list << "#{@email_prep}"
    
    if !@execdir_email_address.nil?
      @email_exec = @execdir_email_address
      @email_list << ", #{@email_exec} "
      @finished_survey.update_column(:exec_dir_notified, true)
    else
      #nil execdir email address - - this is a problem since we want the exec directors to receive these notifications, so we
      #will email to the FinishedSurveyEmailList.all.map(&:email_address) list, as a .bcc
      @bcc_list = "Yes"
    end
    
    #puts "email_list - #{@email_list}"
    
    if @bcc_list == "Yes"
      mail(:subject => "2012 Monitoring Questionnaire completion notification - #{@finished_survey.grantee_name} - #{@finished_survey.project_name}",
         :from => ENV['GMAIL_USER_NAME'],
         :to => @email_list,
         :bcc => FinishedSurveyEmailList.all.map(&:email_address))
    else
      mail(:subject => "2012 Monitoring Questionnaire completion notification - #{@finished_survey.grantee_name} - #{@finished_survey.project_name}",
         :from => ENV['GMAIL_USER_NAME'],
         :to => @email_list)
    end
    
  end
  
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
  
end