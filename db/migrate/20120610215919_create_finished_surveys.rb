class CreateFinishedSurveys < ActiveRecord::Migration
  def change
    create_table :finished_surveys do |t|
      t.string :url
      t.string :grantee_name
      t.string :project_name

      t.timestamps
    end
  end
end
