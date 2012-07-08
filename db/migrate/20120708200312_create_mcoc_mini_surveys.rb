class CreateMcocMiniSurveys < ActiveRecord::Migration
  def change
    create_table :mcoc_mini_surveys do |t|
      t.integer :mcoc_renewal_id
      t.integer :user_id
      t.boolean :dont_ask, :null => false, :default => false
      t.string :response_set_access_code
      t.integer :survey_id

      t.timestamps
    end
  end
end
