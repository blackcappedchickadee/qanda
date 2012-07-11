class MiniSatisfSurvey < Prawn::Document
  
  def initialize(mcoc_renewal_id, response_set_code, grantee_name, project_name, doc_name)
    
    not_provided_text = "<b><color rgb='ff0000'>Not Provided</color></b>"

    @grantee_name = grantee_name
    @project_name = project_name
    response_set = ResponseSet.find_by_access_code(response_set_code)
    response_set_id = response_set.id
    survey_id = response_set.survey_id
    
    survey_section_id = SurveySection.find_by_data_export_identifier_and_survey_id("satisfaction", survey_id)
    
    super(top_margin: 50)
    font_size 16
    text "2012 Monitoring and Evaluation - Mini Satisfaction Survey", :style => :bold 
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
    move_down 10
    
    sat_quest_thoughts = get_response_with_only_one_value("sat_quest_thoughts", response_set_id, survey_section_id)
    
    text "Do you have any thoughts for the questionnaire process you just completed? Please provide your suggestions below."
    font "Times-Roman"
    if sat_quest_thoughts.nil?
      text "#{not_provided_text}", :inline_format => true
    else
      text "#{sat_quest_thoughts}"
    end
    font "Helvetica"  # back to normal
    move_down 10
    
    pgnum_string = "Page <page> of <total> -- #{grantee_name} - #{project_name}" 

    options = { :at => [bounds.left + 0, 0],
                  :width => 700,
                  :align => :left,
                  :size => 9,
                  :start_count_at => 1,
                  :color => "999999" }
    number_pages pgnum_string, options
    
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
             @retval = tmp_answer.short_text
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
  
end