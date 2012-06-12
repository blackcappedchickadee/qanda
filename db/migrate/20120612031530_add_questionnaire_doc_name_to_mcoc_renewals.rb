class AddQuestionnaireDocNameToMcocRenewals < ActiveRecord::Migration
  def change
    add_column :mcoc_renewals, :questionnaire_doc_name, :integer
  end
end
