module SurveyorControllerCustomMethods
  
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
    base.send :before_filter, :obtain_audit_records_for_section, :only => :edit
    base.send :after_filter, :set_previous_section_id, :only => :edit
  end

  # Actions
  def new
    super
    @title = "Available Questionnaires"
  end
  def create
    puts "survey code = #{params[:survey_code]}"
    super
  end
  def show
    super
  end
  def edit
    super
    
    @response_set_code = params[:response_set_code]
    @response_set = ResponseSet.find_by_access_code(@response_set_code)
    @response_set_id = @response_set.id
    @mcoc_user_renewals = McocUserRenewal.where(:response_set_id => @response_set_id)
    if (@mcoc_user_renewals.first != nil)
      @mcoc_renewal_id = @mcoc_user_renewals.first.mcoc_renewal_id
      session[:mcoc_renewals_id] = @mcoc_renewals_id
      @mcoc_renewal = McocRenewal.find_by_id(@mcoc_renewal_id)
      session[:project_name] = @mcoc_renewal.project_name
      session[:grantee_name] = @mcoc_renewal.grantee_name
      session[:response_set_code] = @response_set_code
      
      prepopulate_program_name
      
      session[:quest_section] = params[:section]
      
    end
  end
  def update
    saved = false
    ActiveRecord::Base.transaction do
      @response_set = ResponseSet.find_by_access_code(params[:response_set_code], :include => {:responses => :answer}, :lock => true)
      unless @response_set.blank?
        saved = @response_set.update_attributes(:responses_attributes => ResponseSet.to_savable(params[:r]))
        @response_set.complete! if saved && params[:finish]
        saved &= @response_set.save
      end
    end
    return redirect_with_message(surveyor_finish, :notice, "Completed Questionnaire") if saved && params[:finish]

    respond_to do |format|
      format.html do
        if @response_set.blank?
          return redirect_with_message(available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses'))
        else
          flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
          redirect_to edit_my_survey_path(:anchor => anchor_from(params[:section]), :section => section_id_from(params[:section]))
        end
      end
      format.js do
        ids, remove, question_ids = {}, {}, []
        ResponseSet.trim_for_lookups(params[:r]).each do |k,v|
          v[:answer_id].reject!(&:blank?) if v[:answer_id].is_a?(Array)
          ids[k] = @response_set.responses.find(:first, :conditions => v, :order => "created_at DESC").id if !v.has_key?("id")
          remove[k] = v["id"] if v.has_key?("id") && v.has_key?("_destroy")
          question_ids << v["question_id"]
        end
        render :json => {"ids" => ids, "remove" => remove}.merge(@response_set.reload.all_dependencies(question_ids))
      end
    end
  end
  
  def show_questionnaire
    
    @tmp_response_set_code = params[:response_set_code]
    @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
    @tmp_response_set_id = @tmp_response_set.id
    @mcoc_user_renewal = McocUserRenewal.find_by_response_set_id(@tmp_response_set_id)
    @tmp_mcoc_renewal_id = @mcoc_user_renewal.mcoc_renewal_id
    @tmp_user_id = session[:user_id]
    
    @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
    @tmp_grantee_name = @mcoc_renewal.grantee_name
    @tmp_project_name = @mcoc_renewal.project_name
    
    @tmp_doc_name = @mcoc_renewal.questionnaire_doc_name
    if @tmp_doc_name.blank? 
      @questionnaire_doc_name = 0
    else
      @questionnaire_doc_name = @tmp_doc_name
    end

    @tmp_pdf_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code, :include => {:responses => [:question, :answer]})
    @tmp_pdf_response_set_responses = @tmp_pdf_response_set.responses
    
    #iterate through responses
    @tmp_pdf_response_set_responses.each do |response|
      @question = response.question
    end
    
    respond_to do |format|
      format.pdf do
        questionnaire = QuestionnairePdf.new(@tmp_user_id, @tmp_mcoc_renewal_id, @tmp_response_set_code, @tmp_grantee_name, @tmp_project_name, @questionnaire_doc_name)
        if !questionnaire.nil?
          
          send_data questionnaire.render, filename: "#{@tmp_project_name}-2012-questionnaire.pdf",
                              type: "application/pdf",
                              disposition: "inline"
        end
      end
    end
    
    
  end
  
  
  def audit_status

    puts "in surveyor audit_status............"
    @audit_records = McocRenewalsDataQualityAudit.find_all_by_mcoc_renewal_id(params[:renewal_id])
    @audit_section = SurveySection.find_by_id_and_survey_id(params[:section], params[:survey_id])
    @audit_section_name = @audit_section.title
    
    @tmp_survey_access_code = session[:survey_code] 
    @tmp_response_set_code = session[:response_set_code] 
    
    @tmp_requested_next_section = session[:requested_next_section]
    
    @return_url_verbose = "Click here to return to the #{@audit_section_name} Section to correct."
 
    #@audit_records

  end
  
  
  #custom Action to list the current surveys
  def list_current
      #get the list of instanced (via response_sets) surveys for the current user
      #the precondition (very important) is that these have been instanced/seeded prior
      #refer to lib/tasks/instance_surveys_for_id+"N".rake
      @list_of_instanced_surveys = []
      @user_renewals_instanced_surveys = McocRenewal.joins(:mcoc_user_renewals).where(:mcoc_user_renewals => {:user_id => current_user.id}).order('grantee_name ASC, project_name ASC')
      @user_renewals_instanced_surveys.each do |user_renewals|
        puts "testing #{user_renewals.id}"
        @mcoc_renewals = McocUserRenewal.find_by_mcoc_renewal_id(user_renewals.id)
        
        @completed_date = ""
        @completed_flag = ""
        
        @response_set_for_user = ResponseSet.find_by_id(@mcoc_renewals.response_set_id)
        @survey = Survey.find_by_id(@response_set_for_user.survey_id)
        
        if !@response_set_for_user.completed_at.nil?
          @completed_date = @response_set_for_user.completed_at.in_time_zone("Eastern Time (US & Canada)")
        end
        if @completed_date.blank?
          @completed_flag = "No"
        else  
          @completed_flag = "Yes"
        end
        
        #stuff into the array
        @transitory_surveys = TransitoryInstancedSurvey.new(@survey.access_code, 
                      @response_set_for_user.access_code, 
                      user_renewals.grantee_name, 
                      user_renewals.project_name, @completed_flag, @completed_date)           
        @list_of_instanced_surveys << @transitory_surveys
        
      end
  end
  
  #custom action for showing a Report of Unfinished Instanced Surveys
  def list_instanced_questionnaire_status
      session[:quest_section] = 0
      @report_list = []
      @mcoc_renewals = McocRenewal.find(:all, :order => 'grantee_name ASC, project_name ASC')

      @mcoc_renewals.each do |renewals|
        @completed_date = ""
        @tmp_user_renewals = McocUserRenewal.where(:mcoc_renewal_id => renewals.id)
        @grantee_name = renewals.grantee_name
        @project_name = renewals.project_name
        if @tmp_user_renewals.first.nil?
          puts "nil user renewals found for #{renewals.id}"
          @response_set_access_code = "notinstanced"
          @completed_flag = "No"
          @completed_date = ""
          @survey_access_code = "notinstanced"
        else
          puts "user renewals WERE found for #{renewals.id}"
          @response_set = ResponseSet.where(:id => @tmp_user_renewals.first.response_set_id)
          @response_set_access_code = @response_set.first.access_code
          @survey = Survey.find_by_id(@response_set.first.survey_id)
          if !@response_set.first.completed_at.nil?
            @completed_date = @response_set.first.completed_at.in_time_zone("Eastern Time (US & Canada)")
          end
          if @completed_date.blank?
            @completed_flag = "No"
          else  
            @completed_flag = "Yes"
          end
          @survey_access_code = @survey.access_code
          puts "completed date - #{@completed_date}, completed_flag - #{@completed_flag}"
        end
        
        #populate the model regardless of whether or not we found details 
        @transitory_report_list = TransitoryInstancedSurvey.new(@survey_access_code, 
                      @response_set_access_code, 
                      @grantee_name, 
                      @project_name, @completed_flag, @completed_date)           
        @report_list << @transitory_report_list
        
      end
    
  end
  
  
  def render_context
    
    #since we may have mustaches in place: {{recipient_name}}
    @mcoc_constants_1 = McocConstants.where(:mcoc_constant_name => 'recipient_name')
    @mcoc_constants_2 = McocConstants.where(:mcoc_constant_name => 'deadline_date')
    @mcoc_constants_3 = McocConstants.where(:mcoc_constant_name => 'recipient_email_address')
    
    MustacheContext.new(@mcoc_constants_3.first.mcoc_constant_value, @mcoc_constants_1.first.mcoc_constant_value, @mcoc_constants_2.first.mcoc_constant_value )

  end
  
  # Paths
  def section_id_from(p)
    puts "================ now in section_id_from #{p} ---- #{:keys}"
    
    session[:requested_next_section] = params[:section]
    p.respond_to?(:keys) ? p.keys.first : p
  end

  def anchor_from(p)
    @quest_section_previous = session[:quest_section]
    session[:display_audit_details_for_section] = nil
    puts "------------ leaving #{@quest_section_previous} ----------------"
    #now we check to see if the section we're about to leave hasa required fields that have not been provided...
    @tmp_response_set_code = session[:response_set_code]
    @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
    @tmp_survey = Survey.find(@tmp_response_set.survey_id)
    #only do this with the Monitoring Questionnaire
    #if @tmp_survey.access_code == "2012-monitoring-and-evaluation"
      #puts "will now call obtain_audit_records_for_section ------ "
      #obtain_audit_records_for_section
      #if !@audit_records.nil?
      #  puts "----- $$$$$$$$$$$$$$$$$$$$$$$$$$$ audit records found!!!!!!"
      #  #session[:display_audit_details_for_section] = "Yes"
      #  #display_audit_status
      #end
    #else
      p.respond_to?(:keys) && p[p.keys.first].respond_to?(:keys) ? p[p.keys.first].keys.first : nil
    #end
  end
  
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    #super # available_surveys_path

    @tmp_response_set_code = session[:response_set_code]
    @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
    @tmp_survey = Survey.find(@tmp_response_set.survey_id)

    #only do this with the Monitoring Questionnaire related items
    case @tmp_survey.access_code 
      when "2012-monitoring-and-evaluation"
        put_completed_survey_pdf_to_doclib
        session[:quest_section]
        perform_mini_survey
      when "2012-monitoring-and-evaluation-questionnaire-mini-survey"
        puts "in mini survey logic..."
        put_completed_mini_satisf_survey_pdf_to_doclib
        
        #list_surveys_path
        end_message
        
    else
      end_message
      #list_surveys_path #returns to the list of instanced, available surveys for the given user.
    end
    
  end
  
  def end_message
    end_message_path
  end
  
  private
  
    def set_previous_section_id
      session[:previous_section_id] = params[:section]
      puts "in ----------------------------------------- set_previous_section_id - with #{session[:section]}" 
      
    end
  
  
    def obtain_audit_records_for_section
      puts "obtain_audit_records_for_section: is being called --- YayYyyyyyyyyy!!"
      @first_visit = "0"
      @first_visit = params[:first_visit]
      
      @tmp_response_set_code = params[:response_set_code]
      @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
      @tmp_survey_id = @tmp_response_set.survey_id
      @tmp_survey = Survey.find(@tmp_survey_id)
      
      @tmp_requested_next_section = params[:section]

      #only do this with the Monitoring Questionnaire related items
      puts "----------- #{@tmp_survey.access_code}"
      if @tmp_survey.access_code == "2012-monitoring-and-evaluation"
        
          if @first_visit == "1"
            puts "obtain_audit_records_for_section: first visit......."
            session[:previous_section_id] = params[:section]
          else
           
            puts "obtain_audit_records_for_section: -- previous section analysis begins -- #{session[:previous_section_id]}"
            session[:quest_section] = session[:previous_section_id]
            prev_section_id = session[:quest_section]
    
            #below won't work -- out of sync -- this is the current -- we need the "prior" one...
            #@section_id = params[:section] #the section we're leaving?
            #puts "obtain_audit_records_for_section:   section_id = #{@section_id}..."

            @tmp_response_set_id = @tmp_response_set.id
            @mcoc_user_renewal = McocUserRenewal.find_by_response_set_id(@tmp_response_set_id)
            @tmp_mcoc_renewal_id = @mcoc_user_renewal.mcoc_renewal_id
            @tmp_user_id = session[:user_id]

            @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
            @tmp_grantee_name = @mcoc_renewal.grantee_name
            @tmp_project_name = @mcoc_renewal.project_name

            @quest_audit = QuestionnaireStatus.new(@tmp_user_id, @tmp_mcoc_renewal_id, @tmp_response_set_code, @tmp_grantee_name, @tmp_project_name, prev_section_id)
    
            @audit_records = McocRenewalsDataQualityAudit.find_by_mcoc_renewal_id(@tmp_mcoc_renewal_id)
            session[:quest_section] = params[:section]
    
            if !@audit_records.nil? 
                session[:survey_code] = params[:survey_code]
                session[:response_set_code] = params[:response_set_code]
                session[:requested_next_section] = @tmp_requested_next_section
                puts "obtain_audit_records_for_section: audit records were found !!!!!"
                redirect_to audit_status_path(:section => prev_section_id, :survey_id => @tmp_survey_id, :renewal_id => @tmp_mcoc_renewal_id)
            end
              
           
           
         end
      end
      #
   
    end
    
  
    def prepopulate_program_name
      puts "In prepopulate_program_name... start"
      @tmp_response_set_code = session[:response_set_code]
      puts "@tmp_response_set_code = #{@tmp_response_set_code}..."
      @response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
      if @response_set
        @survey = @response_set.survey
        @tmp_survey_id = @survey.id
        @tmp_response_set_id = @response_set.id
        puts "@tmp_survey_id = #{@tmp_survey_id}"
        @agency_info_export_identifier = 'agency_information'
        #only do this if we are in the relevant (agency information) section...
        @current_survey_section = params[:section]
        #puts "current survey section --->#{@current_survey_section}<----"
        @survey_section_agency_info = SurveySection.find_by_survey_id_and_data_export_identifier(@tmp_survey_id, @agency_info_export_identifier)
        if @survey_section_agency_info 
          #only enter into the core logic if we're dealing with the relevant survey section
          
          #puts "ready for testing..."
          
          if (@current_survey_section.to_s == @survey_section_agency_info.id.to_s) || (@current_survey_section.nil?)
            @tmp_survey_section_agency_info_id = @survey_section_agency_info.id
            #puts "@tmp_survey_section_agency_info_id = #{@tmp_survey_section_agency_info_id}"
            @question_data_export_identifier = 'data_agency_info'
            @question = Question.find_by_survey_section_id_and_data_export_identifier(@tmp_survey_section_agency_info_id, @question_data_export_identifier)
            if @question
              @tmp_question_id = @question.id
              puts "@tmp_question_id = #{@tmp_question_id}"
              @answer_data_export_identifier = 'program_name'
              @answer = Answer.find_by_question_id_and_data_export_identifier(@tmp_question_id, @answer_data_export_identifier)
              @tmp_answer_id = @answer.id
              #puts "@tmp_answer_id = #{@tmp_answer_id}"
              
              @response_for_program_name = Response.find_by_question_id_and_answer_id_and_response_set_id(@tmp_question_id, @tmp_answer_id, @tmp_response_set_id)
              if @response_for_program_name
                puts "response found for program name, do we have a text value?"
                if @response_for_program_name.string_value != nil
                  #puts "... found existing value #{@response_for_program_name.string_value} for program name"
                else
                  #puts "program name is not nil but there was a nil string_value "
                end
              else
                @tmp_project_name = session[:project_name]
                # @finished_survey = FinishedSurvey.create({:url => full_doclib_url, :grantee_name => grantee_name, :project_name => project_name})
                @response_for_program_name = Response.create({:response_set_id => @tmp_response_set_id, :question_id => @tmp_question_id, 
                          :answer_id => @tmp_answer_id, :string_value => @tmp_project_name})
                
              end
            end
          end
        end
        
      end
      
    end
  
    def put_completed_survey_pdf_to_doclib

      @tmp_response_set_code = session[:response_set_code]
      @tmp_grantee_name = session[:grantee_name]
      @tmp_project_name = session[:project_name]
      @tmp_user_id = session[:user_id]
      
      @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
      @tmp_response_set_id = @tmp_response_set.id
      @mcoc_user_renewal = McocUserRenewal.find_by_response_set_id(@tmp_response_set_id)
      @tmp_mcoc_renewal_id = @mcoc_user_renewal.mcoc_renewal_id
      
      session[:mcoc_renewal_id] = @tmp_mcoc_renewal_id

      @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
      @tmp_grantee_name = @mcoc_renewal.grantee_name
      @tmp_project_name = @mcoc_renewal.project_name

      #the automatic (no user intervention) creation of the completed questionnaire pdf and 
      #transmission of the pdf to the external DocLib (via the add WS operation) is being
      #handled by a delayed job, that way the user doesn't need to "wait" for this process to complete
      #since it runs on a separate thread.
      delayed_job = CreateAndSendPdfJob.new
      delayed_job.create_and_put_pdf(@tmp_response_set_code, @tmp_mcoc_renewal_id, @tmp_grantee_name, @tmp_project_name, @tmp_user_id)
  
    end
    
    def put_completed_mini_satisf_survey_pdf_to_doclib
      
      @tmp_response_set_code = session[:response_set_code]
      @tmp_grantee_name = session[:grantee_name]
      @tmp_project_name = session[:project_name]
      @tmp_user_id = session[:user_id]
      
      @tmp_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code)
      @tmp_response_set_id = @tmp_response_set.id
      @mcoc_mini_survey = McocMiniSurvey.find_by_response_set_access_code(@tmp_response_set_code)
      @tmp_mcoc_renewal_id = @mcoc_mini_survey.mcoc_renewal_id
      
      session[:mcoc_renewal_id] = @tmp_mcoc_renewal_id

      @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
      @tmp_grantee_name = @mcoc_renewal.grantee_name
      @tmp_project_name = @mcoc_renewal.project_name

      #the automatic (no user intervention) creation of the completed questionnaire pdf and 
      #transmission of the pdf to the external DocLib (via the add WS operation) is being
      #handled by a delayed job, that way the user doesn't need to "wait" for this process to complete
      #since it runs on a separate thread.
      delayed_job = CreateAndSendPdfJob.new
      delayed_job.create_and_put_pdf_for_mini_satisf_survey(@tmp_response_set_code, @tmp_mcoc_renewal_id, @tmp_grantee_name, @tmp_project_name, @tmp_user_id)
      
    end
    
    def display_audit_status
      puts "......QQQQQQQ  ---------------- in display_audit_status..............."
      #audit_status_path
      #return redirect_to :action => 'audit_status'
      
    end
    
    def perform_mini_survey
       @tmp_user_id = session[:user_id]
       @mcoc_mini_survey = McocMiniSurvey.find_by_user_id(@tmp_user_id)
       if !@mcoc_mini_survey.nil?
         #we won't ask if dont_ask = 1 (true)
         if !@mcoc_mini_survey.dont_ask 
           #redirect to mini_survey lead-in
           session[:mcoc_mini_survey] = @mcoc_mini_survey
           mini_survey_ask_path
         else
           end_message #list_surveys_path
         end
       else
         #we'll insert the "base" values to the mcoc_mini_survey table -- then we'll redirect to ask if they are
         #interested in taking a mini-survey
         @mcoc_mini_survey = McocMiniSurvey.create(:user_id => @tmp_user_id)
         #redirect to mini_survey lead-in
         session[:mcoc_mini_survey] = @mcoc_mini_survey
         mini_survey_ask_path
       end
      
    end
    
end

class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
  
  before_filter :authenticate_user! #authenticate for users before any methods is called
  
end