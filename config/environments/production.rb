Qanda::Application.configure do
    #per surveyor team and documented here: 
    #for now, I'll turn on runtime compilation of assets -- as surveyor was based on rails 2 and the
    #asset pipeline in rails 3 is different now...
    #https://github.com/NUBIC/surveyor/issues/307#issuecomment-5253845
  
    # Settings specified here will take precedence over those in config/application.rb

    # In the development environment your application's code is reloaded on
    # every request. This slows down response time but is perfect for development
    # since you don't have to restart the web server when you make code changes.
    config.cache_classes = false

    # Log error messages when you accidentally call methods on nil.
    config.whiny_nils = true

    # Show full error reports and disable caching
    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

   
    # Print deprecation notices to the Rails logger
    config.active_support.deprecation = :log

    # Only use best-standards-support built into browsers
    config.action_dispatch.best_standards_support = :builtin

    # Raise exception on mass assignment protection for Active Record models
    #config.active_record.mass_assignment_sanitizer = :strict #commented since we backed down from rails 3.2.1 to 3.1.1

    # Log the query plan for queries taking more than this (works
    # with SQLite, MySQL, and PostgreSQL)
    #config.active_record.auto_explain_threshold_in_seconds = 0.5 #commented since we backed down from rails 3.2.1 to 3.1.1

    # Do not compress assets
    config.assets.compress = false

    # Expands the lines which load the assets
    config.assets.debug = true


    # Don't care if the mailer can't send
    #config.action_mailer.raise_delivery_errors = false
    
    #config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true


  end