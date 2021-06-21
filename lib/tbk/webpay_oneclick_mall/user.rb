# frozen_string_literal: true
module Tbk
  module WebpayOneclickMall
    class User < ActiveRecord::Base
      self.table_name = "webpay_oneclick_mall_users"
      belongs_to :user, class_name: 'Spree::User'
      scope :subscribed, ->{ where(subscribed: true) }

      def subscribed?
        subscribed == true
      end
    end
  end
end
