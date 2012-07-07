class AddAttachmentQuestionnaireToFinishedSurvey < ActiveRecord::Migration
  def self.up
    add_column :finished_surveys, :questionnaire_file_name, :string
    add_column :finished_surveys, :questionnaire_content_type, :string
    add_column :finished_surveys, :questionnaire_file_size, :integer
    add_column :finished_surveys, :questionnaire_updated_at, :datetime
  end

  def self.down
    remove_column :finished_surveys, :questionnaire_file_name
    remove_column :finished_surveys, :questionnaire_content_type
    remove_column :finished_surveys, :questionnaire_file_size
    remove_column :finished_surveys, :questionnaire_updated_at
  end
end
