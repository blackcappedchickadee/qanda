class AddSubmittedByAndExecDirNotificationFlagToFinishedSurveys < ActiveRecord::Migration
  def change
    add_column :finished_surveys, :user_id, :integer
    add_column :finished_surveys, :exec_dir_notified, :boolean, :null => false, :default => false
  end
end
