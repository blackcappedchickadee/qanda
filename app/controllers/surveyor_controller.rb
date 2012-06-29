module SurveyorControllerCustomMethods
  
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end

  # Actions
  def new
    super
    @title = "Available Surveys"
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
          return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey')) if saved && params[:finish]

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
  def generate_pdf
    puts "in generate_pdf..."
    @tmp_mcoc_renewal_id = session[:mcoc_renewals_id]
    @tmp_response_set_code = session[:response_set_code]
    @tmp_grantee_name = session[:grantee_name]
    @tmp_project_name = session[:project_name]
    
    @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
    @tmp_doc_name = @mcoc_renewal.questionnaire_doc_name
    if @tmp_doc_name.blank? 
      @questionnaire_doc_name = 0
    else
      @questionnaire_doc_name = @tmp_doc_name
    end
    puts "======= doc_name of completed survey pdf is -- #{@questionnaire_doc_name}"
    

    @tmp_pdf_response_set = ResponseSet.find_by_access_code(@tmp_response_set_code, :include => {:responses => [:question, :answer]})
    @tmp_pdf_response_set_responses = @tmp_pdf_response_set.responses
    
    #iterate through responses
    @tmp_pdf_response_set_responses.each do |response|
      puts "answer_id = #{response.answer_id}, question_id = #{response.question_id}"
      @question = response.question
      puts "question info = #{@question.survey_section_id} - #{@question.text} "
    end
    @test_pdf = CreateAndSendPdfJob.new(@tmp_mcoc_renewal_id, @tmp_response_set_code, "html", @tmp_grantee_name, @tmp_project_name, @questionnaire_doc_name)
    
    @test_pdf.test_pdf
    
    #puts @tmp_pdf_response_set_responses.to_json
    #@tmp_hash_obj = @tmp_pdf_response_set_responses.to_json
    #@json_1 = JSON.parse(@tmp_hash_obj).each do |json_1|
    #  puts "json_1 = #{json_1}"
    #  
    #end

    
  end
  #custom Action
  def list_current
      #get the list of instanced (via response_sets) surveys for the current user
      #the precondition (very important) is that these have been instanced/seeded prior
      #refer to lib/tasks/instance_surveys_for_id+"N".rake
      @list_of_instanced_surveys = []
      puts "Current user = #{current_user.id}"
      
      @user_renewals_instanced_surveys = McocRenewal.joins(:mcoc_user_renewals).where(:mcoc_user_renewals => {:user_id => current_user.id}).order('grantee_name ASC, project_name ASC')
      
      #puts "test_sql = #{@test_sql}"
      
      #@instanced_surveys = McocRenewal.where(:user_id => current_user.id).joins(:mcoc_renewals).order('grantee_name ASC, project_name ASC')
      @user_renewals_instanced_surveys.each do |user_renewals|
        puts "testing #{user_renewals.id}"
        @mcoc_renewals = McocUserRenewal.find_by_mcoc_renewal_id(user_renewals.id)
        
        
        
        @response_set_for_user = ResponseSet.find_by_id(@mcoc_renewals.response_set_id)
        @survey = Survey.find_by_id(@response_set_for_user.survey_id)
        #stuff into the array
        @transitory_surveys = TransitoryInstancedSurvey.new(@survey.access_code, 
                      @response_set_for_user.access_code, 
                      user_renewals.grantee_name, 
                      user_renewals.project_name, nil, nil)           
        @list_of_instanced_surveys << @transitory_surveys
        
      end
  end
  
  #custom action for showing a Report of Unfinished Instanced Surveys
  def list_instanced_questionnaire_status
      @report_list = []
      @mcoc_renewals = McocRenewal.find(:all, :order => 'grantee_name ASC, project_name ASC')
      @mcoc_renewals.each do |renewals|
        @tmp_user_renewals = McocUserRenewal.where(:mcoc_renewals_id => renewals.id)
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
          @completed_date = @response_set.first.completed_at
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
    p.respond_to?(:keys) ? p.keys.first : p
  end

  def anchor_from(p)
    p.respond_to?(:keys) && p[p.keys.first].respond_to?(:keys) ? p[p.keys.first].keys.first : nil
  end
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    #super # available_surveys_path
    put_completed_survey_pdf_to_doclib
    list_surveys_path #returns to the list of instanced, available surveys for the given user.
  end
  
  private
  
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
        puts "current survey section --->#{@current_survey_section}<----"
        @survey_section_agency_info = SurveySection.find_by_survey_id_and_data_export_identifier(@tmp_survey_id, @agency_info_export_identifier)
        if @survey_section_agency_info 
          #only enter into the core logic if we're dealing with the relevant survey section
          
          
          
          if (@current_survey_section.to_s == @survey_section_agency_info.id.to_s) || (@current_survey_section.nil?)
            @tmp_survey_section_agency_info_id = @survey_section_agency_info.id
            puts "@tmp_survey_section_agency_info_id = #{@tmp_survey_section_agency_info_id}"
            @question_data_export_identifier = 'data_agency_info'
            @question = Question.find_by_survey_section_id_and_data_export_identifier(@tmp_survey_section_agency_info_id, @question_data_export_identifier)
            if @question
              @tmp_question_id = @question.id
              puts "@tmp_question_id = #{@tmp_question_id}"
              @answer_data_export_identifier = 'program_name'
              @answer = Answer.find_by_question_id_and_data_export_identifier(@tmp_question_id, @answer_data_export_identifier)
              @tmp_answer_id = @answer.id
              puts "@tmp_answer_id = #{@tmp_answer_id}"
              
              @response_for_program_name = Response.find_by_question_id_and_answer_id(@tmp_question_id, @tmp_answer_id)
              if @response_for_program_name
                puts "response found for program name, do we have a text value?"
                if @response_for_program_name.string_value != nil
                  puts "... found existing value #{@response_for_program_name.string_value} for program name"
                else
                  puts "program name is not nil but there was a nil string_value "
                end
              else
                @tmp_project_name = session[:project_name]
                puts "program name is nil -- this is where we will create a response with #{session[:project_name]} as the project name..."
                # @finished_survey = FinishedSurvey.create({:url => full_doclib_url, :grantee_name => grantee_name, :project_name => project_name})
                @response_for_program_name = Response.create({:response_set_id => @tmp_response_set_id, :question_id => @tmp_question_id, 
                          :answer_id => @tmp_answer_id, :string_value => @tmp_project_name})
                puts "completed the save..."
                
                
              end
            end
          end
        end
        
      end
      
      puts "In prepopulate_program_name... end"
    end
  
  
    def put_completed_survey_pdf_to_doclib
      @tmp_mcoc_renewal_id = session[:mcoc_renewals_id]
      @tmp_response_set_code = session[:response_set_code]
      @tmp_grantee_name = session[:grantee_name]
      @tmp_project_name = session[:project_name]
      
      @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
      @tmp_doc_name = @mcoc_renewal.questionnaire_doc_name
      if @tmp_doc_name.blank? 
        @questionnaire_doc_name = 0
      else
        @questionnaire_doc_name = @tmp_doc_name
      end
      puts "======= doc_name of completed survey pdf is -- #{@questionnaire_doc_name}"
      @response_set = ResponseSet.find_by_access_code(@tmp_response_set_code, :include => {:responses => [:question, :answer]})
      
      if @response_set
        @survey = @response_set.survey
        html = render_to_string(:layout => false , :action => "show")
        
        #the automatic (no user intervention) creation of the completed questionnaire pdf and 
        #transmission of the pdf to the external DocLib (via the add WS operation) is being
        #handled by a delayed job, that way the user doesn't need to "wait" for this process to complete
        #since it runs on a separate thread.
        delayed_job = CreateAndSendPdfJob.new(@tmp_mcoc_renewal_id, @tmp_response_set_code, html, @tmp_grantee_name, @tmp_project_name, @questionnaire_doc_name)
        delayed_job.create_and_put_pdf
        
      end

    end
    
end

class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
  
  before_filter :authenticate_user! #authenticate for users before any methods is called
  
end