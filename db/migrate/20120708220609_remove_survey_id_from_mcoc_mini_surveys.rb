class RemoveSurveyIdFromMcocMiniSurveys < ActiveRecord::Migration
  def up
    remove_column :mcoc_mini_surveys, :survey_id
  end

  def down
    add_column :mcoc_mini_surveys, :survey_id, :integer
  end
end
