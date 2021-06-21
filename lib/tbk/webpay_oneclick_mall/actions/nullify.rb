# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class Nullify < Tbk::WebpayOneclickMall::Core::Base
    def initialize(commerce_id, buy_order, authorized_amount, authorization_code, nullify_amount)
      super
      @commerce_id = commerce_id
      @buy_order = buy_order
      @authorized_amount = authorized_amount
      @authorization_code = authorization_code
      @nullify_amount = nullify_amount
    end

    private

    def payload
      {
        input:
        {
          commerceId: @commerce_id,
          buyOrder:  @buy_order,
          authorizedAmount:@authorized_amount,
          authorizationCode: @authorization_code,
          nullifyAmount: @@nullify_amount
        }
      }
    end

  end
end
