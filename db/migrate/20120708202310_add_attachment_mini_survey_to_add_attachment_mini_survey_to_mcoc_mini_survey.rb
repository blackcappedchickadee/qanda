class AddAttachmentMiniSurveyToAddAttachmentMiniSurveyToMcocMiniSurvey < ActiveRecord::Migration
  def self.up
    add_column :mcoc_mini_surveys, :mini_survey_file_name, :string
    add_column :mcoc_mini_surveys, :mini_survey_content_type, :string
    add_column :mcoc_mini_surveys, :mini_survey_file_size, :integer
    add_column :mcoc_mini_surveys, :mini_survey_updated_at, :datetime
  end

  def self.down
    remove_column :mcoc_mini_surveys, :mini_survey_file_name
    remove_column :mcoc_mini_surveys, :mini_survey_content_type
    remove_column :mcoc_mini_surveys, :mini_survey_file_size
    remove_column :mcoc_mini_surveys, :mini_survey_updated_at
  end
end
