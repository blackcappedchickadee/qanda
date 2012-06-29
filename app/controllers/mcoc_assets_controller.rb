class McocAssetsController < ApplicationController
  before_filter :authenticate_user! #authenticate for users before any methods is called

  def listadditionalassets
    @response_set_code = params[:response_set_code]
    @response_set = ResponseSet.find_by_access_code(@response_set_code)
    @response_set_id = @response_set.id
    @mcoc_user_renewals = McocUserRenewal.where(:response_set_id => @response_set_id)
    @mcoc_renewals_id = @mcoc_user_renewals.first.mcoc_renewal_id
    @mcoc_renewal = McocRenewal.find_by_id(@mcoc_renewals_id)
    session[:mcoc_renewals_id] = @mcoc_renewal.id
    session[:return_to] = request.fullpath
    
    (10 - @mcoc_renewal.mcoc_assets.length).times { @mcoc_renewal.mcoc_assets.build }
    
    respond_to do |format|
      format.html # 
      format.json { render json: @mcoc_renewals }
    end
  end
  
  def show
    @tmp_mcoc_asset_id = params[:mcoc_asset_id]
    @mcoc_asset = McocAsset.find(@tmp_mcoc_asset_id)
    send_file @mcoc_asset.supporting_doc.path, :type => @mcoc_asset.supporting_doc_content_type, :disposition => 'inline'  
  end
  
  def upload
    @handle_delete_additional_attachment = params[:handle_delete_additional_attachment]
    @mcoc_renewal_id = session[:mcoc_renewals_id]
    @mcoc_renewal = McocRenewal.find(@mcoc_renewal_id)
    @supporting_doc_folder_id = @mcoc_renewal.supporting_doc_folder_id
    session[:supporting_doc_folder_id] = @supporting_doc_folder_id
    if @handle_delete_additional_attachment == "Y"
      @mcoc_asset_id = params[:mcoc_asset_id]
      @mcoc_asset = @mcoc_renewal.mcoc_assets.find(@mcoc_asset_id)  
      @mcoc_asset_doc_name = @mcoc_asset.doc_name
      if (@mcoc_asset.destroy)
        #Delete file from DocLib via web service call:
        remove_from_doclib
        respond_to do |format|
          format.js { render :js => "window.location.replace('#{additional_doc_path}');" }
        end
      end
    else
      if (@mcoc_renewal.update_attributes(params[:mcoc_renewal]))
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end
    end
  end
  
  private
  
  def remove_from_doclib
    mcoc_group_id = Rails.configuration.liferaymcocgroupid
    liferay_ws = LiferayDocument.new
    retval = liferay_ws.delete(mcoc_group_id, @supporting_doc_folder_id, @mcoc_asset_doc_name)
  end 

end
