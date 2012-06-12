class CreateFinishedSurveyEmailLists < ActiveRecord::Migration
  def change
    create_table :finished_survey_email_lists do |t|
      t.string :name
      t.string :email_address

      t.timestamps
    end
  end
end
