# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class InitInscription < Tbk::WebpayOneclickMall::Core::Base
    def initialize(username, email, return_url)
      super
      @username   = username
      @email      = email
      @return_url = return_url
    end

    private

    def payload
      {
        input:
          {
            email:     @email,
            returnUrl: @return_url,
            username:  @username,
          }
      }
    end

  end
end
