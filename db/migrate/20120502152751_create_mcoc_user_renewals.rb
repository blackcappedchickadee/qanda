class CreateMcocUserRenewals < ActiveRecord::Migration
  def change
    create_table :mcoc_user_renewals do |t|
      t.integer :user_id
      t.integer :mcoc_renewals_id
      t.integer :response_set_id

      t.timestamps
    end
  end
end
