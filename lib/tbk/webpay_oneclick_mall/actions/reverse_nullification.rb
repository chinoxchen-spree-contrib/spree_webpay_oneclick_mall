# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class ReverseNullification < Tbk::WebpayOneclickMall::Core::Base
    def initialize(buy_order, nullify_amount, commerce_id)
      super
      @buy_order = buy_order
      @nullify_amount = nullify_amount
      @commerce_id = commerce_id
    end

    private

    def payload
      {
        input:
        {
          commerceId: @commerce_id,
          buyOrder:  @buy_order,
          nullifyAmount: @nullify_amount
        }
      }
    end

  end
end
