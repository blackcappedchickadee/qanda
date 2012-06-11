class Survey < ActiveRecord::Base
    include Surveyor::Models::SurveyMethods
    def title
      "#{super}"
    end
  end