class AddDocNameToMcocMiniSurveys < ActiveRecord::Migration
  def change
    add_column :mcoc_mini_surveys, :doc_name, :integer
  end
end
