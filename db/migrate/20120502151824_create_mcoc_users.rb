class CreateMcocUsers < ActiveRecord::Migration
  def change
    create_table :mcoc_users do |t|
      t.integer :external_user_id

      t.timestamps
    end
  end
end
