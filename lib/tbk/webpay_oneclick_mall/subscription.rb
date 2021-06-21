# frozen_string_literal: true
module Tbk
  module WebpayOneclickMall
    class Subscription
      def init_inscription username, email, return_url
        if Rails.env.production?
          payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall' ).first
          Transbank::Webpay::Oneclick::Base.commerce_code = payment_method.preferences[:mall_commerce_code]
          Transbank::Webpay::Oneclick::Base.api_key = payment_method.preferences[:api_key]
          Transbank::Webpay::Oneclick::Base.integration_type = :LIVE
        end

        init_inscription = Transbank::Webpay::Oneclick::MallInscription::start(
          user_name: username, email: email, response_url: return_url
        )
      end

      def finish_inscription token
        if Rails.env.production?
          payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall' ).first
          Transbank::Webpay::Oneclick::Base.commerce_code = payment_method.preferences[:mall_commerce_code]
          Transbank::Webpay::Oneclick::Base.api_key = payment_method.preferences[:api_key]
          Transbank::Webpay::Oneclick::Base.integration_type = :LIVE
        end

        finish_inscription = Transbank::Webpay::Oneclick::MallInscription::finish(token: token)
      end

      def remove_inscription username, tbk_user
        if Rails.env.production?
          payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall' ).first
          Transbank::Webpay::Oneclick::Base.commerce_code = payment_method.preferences[:mall_commerce_code]
          Transbank::Webpay::Oneclick::Base.api_key = payment_method.preferences[:api_key]
          Transbank::Webpay::Oneclick::Base.integration_type = :LIVE
        end
        
        Transbank::Webpay::Oneclick::MallInscription::delete(user_name: username, tbk_user: tbk_user)
      end
    end
  end
end