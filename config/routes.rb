Qanda::Application.routes.draw do
  get "mcoc_assets/index"

  resources :mcoc_renewals
  resources :mcoc_assets

  get "asset_other/index"

  get "asset_ude/index"

  get "static_pages/notactive"

  #devise_for :users
  devise_for :users, :controllers => {:sessions => "my_sessions", :registrations => "registrations", :passwords => "passwords"}

  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  root :to => "home#index"
  devise_scope :user do
    match "/autosignin", :controller=>"my_sessions", :action=>"autosignin"
    
    match "/surveys/list_current", :to => "surveyor#list_current", :as => "list_surveys", :via => :get
    match "/surveys/questionnaire_status", :to => "surveyor#list_instanced_questionnaire_status", :as => "questionnaire_status", :via => :get
    
    #match "/surveys/:survey_code/:response_set_code.pdf", :to => "surveyor#export", :as => "generate_pdf", :via => :get
    #match "/surveys/:survey_code/get_pdf/:response_set_code", :to => "surveyor#generate_pdf", :as => "get_pdf", :via => :get
    match "/surveys/:survey_code/questionnaire/:response_set_code", :to => "surveyor#show_questionnaire", :as => "show_questionnaire", :via => :get
    
    match "/asset_ude/:renewals_id", :to => "asset_ude#index", :as => "asset_ude", :via => :get
    match "/asset_ude/:renewals_id/new", :to => "asset_ude#new", :as =>"asset_ude_new", :via => :post
    
    match "/asset_other/:renewals_id", :to => "asset_other#index", :as => "asset_other", :via => :get
    
    match "/surveys/:survey_code/:response_set_code/attachments/ude_report", :to => "mcoc_renewals#listudereport", :as => "ude_report"
    
    match "/surveys/:survey_code/:response_set_code/attachments/ude_report/show", :to => "mcoc_renewals#showudereport", :as => "ude_report_show", :via => :get
    
    match "/surveys/:survey_code/:response_set_code/attachments/apr_report", :to => "mcoc_renewals#listaprreport", :as => "apr_report"
    
    match "/surveys/:survey_code/:response_set_code/attachments/apr_report/show", :to => "mcoc_renewals#showaprreport", :as => "apr_report_show", :via => :get
    
    match "/surveys/:survey_code/:response_set_code/attachments/additional_doc", :to => "mcoc_assets#listadditionalassets", :as => "additional_doc"
    
    match "/surveys/:survey_code/:response_set_code/attachments/additional_doc/upload", :to => "mcoc_assets#upload", :as => "additional_doc_upload"
    
    match "/surveys/:mcoc_asset_id/:response_set_code/attachments/additional_doc/show", :to => "mcoc_assets#show", :as => "additional_asset_show", :via => :get
   
    match "/surveys/mini_survey", :to => "mcoc_mini_survey#index", :as => "mini_survey_ask", :via => :get
    
    match "/surveys/mini_survey", :to => "mcoc_mini_survey#handle_mini_survey_pref", :as => "handle_mini_survey_pref"


  end
  
 
  

end
