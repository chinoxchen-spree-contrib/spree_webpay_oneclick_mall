module Spree
  module Api
    module V2
      module Storefront
        module Account
          class OneclickMallUsersController < ::Spree::Api::V2::ResourceController
            before_action :require_spree_current_user

            def index
              webpay_oneclick_mall_user = spree_current_user.webpay_oneclick_mall_user
              render json: {
                subscribed: webpay_oneclick_mall_user.subscribed,
                oneclick_auth_code: webpay_oneclick_mall_user.authorization_code,
                oneclick_card_type: webpay_oneclick_mall_user.card_type,
                oneclick_card_number: webpay_oneclick_mall_user.card_number,
                oneclick_updated_at: webpay_oneclick_mall_user.created_at
              }, status: 200
            rescue
              render json: { success: false, message: 'no user' }, status: 400
            end
          end
        end
      end
    end
  end
end