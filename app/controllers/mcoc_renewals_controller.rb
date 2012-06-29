class McocRenewalsController < ApplicationController
  before_filter :authenticate_user! #authenticate for users before any methods is called

  def index
    @mcoc_renewals = McocRenewal.all
  end

  def new
    @mcoc_renewals = McocRenewal.new
  end

  def create
    @mcoc_renewals = McocRenewal.new(params[:mcoc_renewals])
    if @mcoc_renewals.save
      redirect_to mcoc_renewals_url, :notice => "Successfully created mcoc renewals."
    else
      render :action => 'new'
    end
  end

  def edit
    @mcoc_renewals = McocRenewal.find(params[:id])
  end

  def update
    @mcoc_renewal = McocRenewal.find(params[:id])
    
    @mcoc_group_id = Rails.configuration.liferaymcocgroupid
    @hud_report_folder_id = @mcoc_renewal.hud_report_folder_id
    @apr_report_folder_id = @mcoc_renewal.apr_report_folder_id
    @doc_name = @mcoc_renewal.doc_name
    @apr_report_doc_name = @mcoc_renewal.apr_report_doc_name
    
    @liferay_ws = LiferayDocument.new
    
    @delete_flag = params[:clear_attachment_ude]
    if @delete_flag == "1" 
       @liferay_ws_result = @liferay_ws.delete(@mcoc_group_id, @hud_report_folder_id, @doc_name)
       @mcoc_renewal.update_attributes(:doc_name => nil)
       @mcoc_renewal.update_attribute(:attachment_ude, nil)
       redirect_to(session[:return_to] || default)
       session[:return_to] = nil
    else
      
      @delete_flag = params[:clear_attachment_apr]
      
      if @delete_flag == "1" 
         @liferay_ws_result = @liferay_ws.delete(@mcoc_group_id, @apr_report_folder_id, @apr_report_doc_name)
         @mcoc_renewal.update_attributes(:apr_report_doc_name => nil)
         @mcoc_renewal.update_attribute(:attachment_apr, nil)
         redirect_to(session[:return_to] || default)
         session[:return_to] = nil
      else
      
        @tmp_report_type = params[:mcoc_renewal][:report_type]
        
        if @tmp_report_type == "ude_report"
          @uploaded_file = params[:mcoc_renewal][:attachment_ude].tempfile
          @uploaded_file_name_extension = params[:mcoc_renewal][:attachment_ude].original_filename.split('.').last
          @uploaded_file_name = "UDE Completeness Report - #{session[:project_name]}.#{@uploaded_file_name_extension}"
          @external_doclib_folder_id = @hud_report_folder_id
          @external_doc_name = @doc_name
        else
          @uploaded_file = params[:mcoc_renewal][:attachment_apr].tempfile
          @uploaded_file_name_extension = params[:mcoc_renewal][:attachment_apr].original_filename.split('.').last
          @uploaded_file_name = "APR Report - #{session[:project_name]}.#{@uploaded_file_name_extension}"
          @external_doclib_folder_id = @apr_report_folder_id
          @external_doc_name = @apr_report_doc_name
        end
      
        @uploaded_file_desc = ""
        @tmp = File.open(@uploaded_file, 'rb').read
        @base64_uploaded_file = Base64.encode64(@tmp)
      
      
        if @external_doc_name.blank?
          
          @added_result = @liferay_ws.add(@mcoc_group_id, @external_doclib_folder_id, @uploaded_file_name, @uploaded_file_desc, @base64_uploaded_file)
          #update the given mcoc_renewal record with the uuid that we just generated due to the addition of the document in the doclib.
          @added_doc_name = @added_result[:doc_name]
          @added_primary_key = @added_result[:primary_key]
          #call the webservice that applies specific permissions on the file (primary_ley) just added to the document library:
          @liferay_ws_permission = LiferayPermission.new
          @company_id = Rails.configuration.liferaycompanyid
          @role_id = Rails.configuration.liferaymcocmonitoringcmterole
          @name = Rails.configuration.liferaywsdldlfileentryname
          @action_ids = Rails.configuration.liferaymcocmonitoringcmteroleactionidsfile
          @liferay_ws_permission.add_for_mcoc_user(@mcoc_group_id, @company_id, @name, @added_primary_key, @role_id, @action_ids)
          #and lastly, update the mcoc_renewal contoller with the doc_name we got back from the ws "add" call above...
          if @tmp_report_type == "ude_report"
            @mcoc_renewal.update_attributes(:doc_name => @added_doc_name)
          else
            @mcoc_renewal.update_attributes(:apr_report_doc_name => @added_doc_name)
          end 
        else
          #since we most likely have an existing file already uploaded, we need to update the existing document.
          #To be extra careful, we will check that it exists in the doclib, then issue the call to update the doclib entry
          @liferay_ws_result = @liferay_ws.get(@mcoc_group_id, @external_doclib_folder_id, @external_doc_name)
          if @liferay_ws_result == "found"
            #we need to update, as opposed to add
            @liferay_ws.update(@mcoc_group_id, @external_doclib_folder_id, @external_doc_name, @uploaded_file_name, @uploaded_file_desc, @base64_uploaded_file)
          end
        end
      
        if @mcoc_renewal.update_attributes(params[:mcoc_renewal])
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end
  
      end
      
    end
  end
  
  def listudereport
    @response_set_code = params[:response_set_code]
    @response_set = ResponseSet.find_by_access_code(@response_set_code)
    @response_set_id = @response_set.id
    @mcoc_user_renewals = McocUserRenewal.where(:response_set_id => @response_set_id)
    @mcoc_renewals_id = @mcoc_user_renewals.first.mcoc_renewal_id
    @mcoc_renewal = McocRenewal.find_by_id(@mcoc_renewals_id)
    session[:mcoc_renewals_id] = @mcoc_renewal.id
    session[:return_to] = request.fullpath
    respond_to do |format|
        format.html # 
        format.json { render json: @mcoc_renewals }
    end
  end
  
  def listaprreport
    @response_set_code = params[:response_set_code]
    @response_set = ResponseSet.find_by_access_code(@response_set_code)
    @response_set_id = @response_set.id
    @mcoc_user_renewals = McocUserRenewal.where(:response_set_id => @response_set_id)
    @mcoc_renewals_id = @mcoc_user_renewals.first.mcoc_renewal_id
    @mcoc_renewal = McocRenewal.find_by_id(@mcoc_renewals_id)
    session[:mcoc_renewals_id] = @mcoc_renewal.id
    session[:return_to] = request.fullpath
    respond_to do |format|
        format.html # 
        format.json { render json: @mcoc_renewals }
    end
  end
  
  
  def showudereport
    @tmp_mcoc_renewal_id = session[:mcoc_renewals_id]
    @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
    send_file @mcoc_renewal.attachment_ude.path, :type => @mcoc_renewal.attachment_ude_content_type, :disposition => 'inline' 
  end
  def showaprreport
    @tmp_mcoc_renewal_id = session[:mcoc_renewals_id]
    @mcoc_renewal = McocRenewal.find(@tmp_mcoc_renewal_id)
    send_file @mcoc_renewal.attachment_apr.path, :type => @mcoc_renewal.attachment_apr_content_type, :disposition => 'inline' 
  end

  
end
