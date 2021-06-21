class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_oneclick_notifications do |t|
      t.integer :payment_id
      t.integer :order_id
      t.timestamps
    end
  end
end
