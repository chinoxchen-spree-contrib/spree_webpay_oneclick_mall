module Spree::UserDecorator
  def self.prepended(base)
    base.has_one :webpay_oneclick_mall_user, class_name: 'Tbk::WebpayOneclickMall::User',  foreign_key: :user_id
  end
end

Spree::User.prepend Spree::UserDecorator