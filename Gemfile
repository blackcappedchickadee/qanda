source 'http://rubygems.org'

gem 'rails', '3.1.3' # was '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'



# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails',   '~> 3.1.5'
gem 'coffee-rails', '~> 3.1.1'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'
gem 'uglifier', '>= 1.0.3'


gem 'jquery-rails'

group :production do
  # gems for heroku go here
  # gem "pg"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'formtastic', '1.2.4'
gem 'haml'

# For user authentication
gem 'devise'

# For layout and helpers generation
gem 'nifty-generators', :group => :development

#For Surveyor
gem "surveyor", "0.22.0"

gem 'pdfkit'
gem 'wkhtmltopdf-binary' # OSX specific -- use wkhtmltopdf on *nix

# For console progress feedback
gem 'progress_bar'

# For uploading files
gem 'paperclip'
gem 'mocha', :group => :test

#for web services consumption
gem 'savon'

#for delayed jobs - especially when we autogenerate a completed questionnaire PDF and
#put it on an external DocLib via a web services call. This is a long running process
#and is an excellent candidate for the delayed_job gem
#to enqueue jobs
gem 'delayed_job_active_record'
#to run enqueued jobs
gem 'daemons'

#using prawn for an alternative layout for generated PDFs of completed questionnaires (questions as well as answers)
#(as opposed to using webkit based PDF renderers such as pdfkit)
gem 'prawn'



