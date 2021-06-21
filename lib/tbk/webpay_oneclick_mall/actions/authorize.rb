# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class Authorize < Tbk::WebpayOneclickMall::Core::Base
    def initialize(username, tbk_user, buy_order, commerce_id, amount, shares_number)
      super
      @username   = username
      @tbk_user   = tbk_user
      @buy_order = buy_order
      @commerce_id = @commerce_codes[commerce_id]
      @amount =  amount
      @shares_number = shares_number
    end

    def valid_payment?
      response_body[:stores_output] && response_body[:stores_output][:response_code].eql?("0")
    end

    private

    def payload
      {
        input:
          {
            username:  @username,
            tbkUser:   @tbk_user,
            buyOrder:  @buy_order,
            storesInput:{
              commerceId: @commerce_id,
              buyOrder: @buy_order,
              amount: @amount,
              sharesNumber: @shares_number
            }
          }
      }
    end

  end
end
