# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Actions
  class RemoveInscription < Tbk::WebpayOneclickMall::Core::Base
    def initialize(username, tbk_user)
      super
      @username   = username
      @tbk_user   = tbk_user
    end

    private

    def payload
      {
        input:
        {
          tbkUser:   @tbk_user,
          username:  @username,
        }
      }
    end

  end
end
