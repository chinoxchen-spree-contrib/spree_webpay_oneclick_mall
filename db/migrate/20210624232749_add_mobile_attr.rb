class AddMobileAttr < ActiveRecord::Migration[6.1]
  def change
    add_column :webpay_oneclick_mall_users, :mobile, :boolean, default: false
  end
end
