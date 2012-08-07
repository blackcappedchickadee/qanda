class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :_set_current_session # Set a filter that is invoked on every request
  before_filter :normal_cookies_for_ie_in_iframes!
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User)
        available_surveys_path
      else
        super
      end
  end
  
  protected
  def _set_current_session
    # Most of the time, we wouldn't access the session from a model, since it
    # flies in the face of the Rails MVC convention; however - there are some 
    # edge cases where we need to access - such as the case when uploading multiple
    # attachments at once - see mcoc_asset model. While we're uploading multiple
    # attachments, we have an after_save method where we consume an external web
    # service that uploads the attachment to an external Document Library. 
    # This web service requires a "parent" folder id which designates
    # where the attachment is to be saved. This parent folder id is what we're
    # placing in the session (via mcoc_assets_controller) -> supporting_doc_folder_id.
    
    # http://stackoverflow.com/questions/4280044/rails-accessing-session-in-model
    # Define an accessor. The session is always in the current controller
    # instance in @_request.session. So we need a way to access this in
    # our model
    accessor = instance_variable_get(:@_request)
    
    # This defines a method session in ActiveRecord::Base. If your model
    # inherits from another Base Class (when using MongoMapper or similar),
    # insert the class here.
    ActiveRecord::Base.send(:define_method, "session", proc {accessor.session})
  end
  

  
  
end
