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
    @mcoc_user_renewals = McocUserRenewals.where(:response_set_id => @response_set_id)
    @mcoc_renewals_id = @mcoc_user_renewals.first.mcoc_renewals_id
    session[:mcoc_renewals_id] = @mcoc_renewals_id
    @mcoc_renewal = McocRenewals.find_by_id(@mcoc_renewals_id)
    session[:project_name] = @mcoc_renewal.project_name
    session[:grantee_name] = @mcoc_renewal.grantee_name
    session[:response_set_code] = @response_set_code
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
  #custom Action
  def list_current
      #get the list of instanced (via response_sets) surveys for the current user
      #the precondition (very important) is that these have been instanced/seeded prior
      #refer to lib/tasks/instance_surveys_for_id+"N".rake
      @list_of_instanced_surveys = []
      puts "Current user = #{current_user.id}"
      @instanced_surveys = McocUserRenewals.where(:user_id => current_user.id)
      @instanced_surveys.each do |survey|
        @mcoc_renewals = McocRenewals.find_by_id(survey.mcoc_renewals_id)
        @response_set_for_user = ResponseSet.find_by_id(survey.response_set_id)
        @survey = Survey.find_by_id(@response_set_for_user.survey_id)
        #stuff into the array
        @transitory_surveys = TransitoryInstancedSurveys.new(@survey.access_code, 
                      @response_set_for_user.access_code, 
                      @mcoc_renewals.grantee_name, 
                      @mcoc_renewals.project_name)           
        @list_of_instanced_surveys << @transitory_surveys
        
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
    def put_completed_survey_pdf_to_doclib
      @tmp_mcoc_renewal_id = session[:mcoc_renewals_id]
      @tmp_response_set_code = session[:response_set_code]
      @tmp_grantee_name = session[:grantee_name]
      @tmp_project_name = session[:project_name]
      
      @mcoc_renewal = McocRenewals.find(@tmp_mcoc_renewal_id)
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