module Spree
  module PaymentDecorator
    def self.prepended(base)
      base.scope :from_oneclick_mall, -> { joins(:payment_method).where(spree_payment_methods: {type: PaymentMethod::WebpayOneclickMall.to_s}) }
    end

    def by_webpay_ws_token token
      self.find_by("webpay_params -> '#{Tbk::WebpayWSCore::Constant::TBK_TOKEN}' = ?", token)
    end

    def oneclick_mall?
      self.payment_method.type == Spree::PaymentMethod::WebpayOneclickMall.to_s
    end

    def oneclick_params_values key
      begin
        webpay_params[key] ? JSON.parse(webpay_params[key]) : {}
      rescue JSON::ParserError => error
        Rails.logger.error error
        return {}
      end
    end

    def oneclick_params_authorize
      @oneclick_authorize_params ||= oneclick_params_values("authorize")
    end

    def oneclick_params_detail
      oneclick_params_authorize["stores_output"]
    end

    def oneclick_params_authorization_date
      oneclick_params_authorize["authorization_date"]
    end

    def oneclick_params_authorization_code
      oneclick_params_detail["authorization_code"]
    end

    def oneclick_params_response_code
      oneclick_params_detail["response_code"]
    end

    def oneclick_params_amount
      oneclick_params_detail["amount"]
    end

    def oneclick_params_payment_type_code
      oneclick_params_detail["payment_type"]
    end

    def oneclick_params_shares_number
      oneclick_params_detail["shares_number"]
    end

    def oneclick_params_commerce_id
      oneclick_params_detail["commerce_id"]
    end

    def oneclick_params_commerce_code
      WebpayOneclickMallConfig::COMMERCE_CODE.key(oneclick_params_commerce_id) rescue nil
    end

    def oneclick_params_buy_order
      oneclick_params_detail["buy_order"]
    end

    def oneclick_params_payment_type
      Tbk::WebpayOneclickMall::Core::Constant::PAYMENT_TYPES[oneclick_params_payment_type_code]
    end

    def oneclick_user_params
      @oneclick_user_params ||= oneclick_params_values("oneclick_user")
    end

    def oneclick_user
      if oneclick_user_params.present?
        Tbk::WebpayOneclickMall::User.find_by(id: oneclick_user_params_authorize["id"])
      end
    end

    def oneclick_params_card_number
      oneclick_user_params["card_number"]
    end

    def oneclick_params_card_origin
      oneclick_user_params["card_origin"]
    end

    def oneclick_params_card_type
      oneclick_user_params["card_type"]
    end

    def oneclick_params_subscription_authorization_code
      oneclick_user_params["authorization_code"]
    end

    def oneclick_params_subscription_token
      oneclick_user_params["token"]
    end

    def oneclick_params_tbk_user
      oneclick_user_params["tbk_user"]
    end
  end
end

::Spree::Payment.prepend Spree::PaymentDecorator
