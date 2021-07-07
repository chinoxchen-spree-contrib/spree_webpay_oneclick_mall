# frozen_string_literal: true
module Tbk
  module WebpayOneclickMall
    class Payment
      def authorize username, tbk_user, buy_order, amount, parent_buy_order
        payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall' ).first

        if Rails.env.production?
          Transbank::Webpay::Oneclick::Base.commerce_code = payment_method.preferences[:mall_commerce_code]
          Transbank::Webpay::Oneclick::Base.api_key = payment_method.preferences[:api_key]
          Transbank::Webpay::Oneclick::Base.integration_type = :LIVE
        end

        details = [
                    {
                      commerce_code: payment_method.preferences[:payment_commerce_code],
                      buy_order: buy_order,
                      amount: amount
                    }
                  ]

        Transbank::Webpay::Oneclick::MallTransaction::authorize(username: username,
                                                                tbk_user: tbk_user,
                                                                parent_buy_order: parent_buy_order,
                                                                details: details)

        #Actions::Authorize.new(username, tbk_user, buy_order, commerce_id, amount, shares_number)
      end

      # def reverse buy_order
      #   Actions::Reverse.new(buy_order)
      # end

      # def nullify buy_order, authorized_amount, authorization_code, nullified_amount
      #   Actions::Nullify.new(buy_order, authorized_amount, authorization_code, nullified_amount)
      # end

      # def reverse_nullification buy_order, nullify_amount, commerce_id
      #   Actions::ReverseNullification.new(buy_order, nullify_amount, commerce_id)
      # end
    end
  end
end