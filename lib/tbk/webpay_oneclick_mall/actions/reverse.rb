# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class Reverse < Tbk::WebpayOneclickMall::Core::Base
    def initialize(buy_order)
      super
      @buy_order = buy_order
    end

    private

    def payload
      {
        input:
        {
          buyOrder:  @buy_order
        }
      }
    end

  end
end
