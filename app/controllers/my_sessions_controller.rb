class MySessionsController < Devise::SessionsController

  protect_from_forgery :except => :autosignin
  
  #TODO: will also want to establish a firewall rule and perform IP checking

#your session logic here

# GET /users/sign_in
  def new
    redirect_to static_pages_notactive_path
  end

  # POST /users/sign_in
  #def create
    
  #end
  
  
  # POST /autosignin
  def autosignin
    #LiferayFolder.new(11801)
    @ext_user_id = params[:ext_user_id] 
    @user_session = McocExtappSession.where(:external_user_id => @ext_user_id, :is_active => true)
    if (@user_session.first != nil)
      #obtain mcoc_users mapping
      @mcoc_user = McocUser.where(:external_user_id => @ext_user_id)
      if (@mcoc_user.first != nil)
        @user_auto_id = @mcoc_user.first.id
        @user_auto = User.where(:id => @user_auto_id)
        if (@user_auto.first != nil) 
          session[:user_id] = @mcoc_user.first.id
          sign_in(:user, User.find(@user_auto))
          redirect_to list_surveys_path
        else
          redirect_to static_pages_notactive_path
        end
      else
        redirect_to static_pages_notactive_path
      end 
    else
      redirect_to static_pages_notactive_path
    end
  end
  


end
