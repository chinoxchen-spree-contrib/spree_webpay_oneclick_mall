# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class FinishInscription < Tbk::WebpayOneclickMall::Core::Base
    def initialize(token)
      super
      @token = token
    end

    private

    def payload
      {
        input:
        {
          token:  @token
        }
      }
    end

  end
end
