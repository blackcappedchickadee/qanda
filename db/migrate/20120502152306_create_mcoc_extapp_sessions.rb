class CreateMcocExtappSessions < ActiveRecord::Migration
  def change
    create_table :mcoc_extapp_sessions do |t|
      t.integer :external_user_id
      t.boolean :is_active, :default => false

      t.timestamps
    end
  end
end
