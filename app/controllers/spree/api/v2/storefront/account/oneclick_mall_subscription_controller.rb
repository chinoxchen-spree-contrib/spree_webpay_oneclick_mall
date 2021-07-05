module Spree
  module Api
    module V2
      module Storefront
        module Account
          class OneclickMallSubscriptionController < ::Spree::Api::V2::ResourceController
            before_action :require_spree_current_user

            def subscribe
              user = spree_current_user

              if user.blank?
                raise(ActiveRecord::RecordNotFound)
              end

              username = user.id
              email = user.email
              init_subscription = Tbk::WebpayOneclickMall::Subscription.new.init_inscription(username,
                email,
                oneclick_mall_subscribe_confirmation_url)


              if init_subscription.token.present? && init_subscription.url_webpay.present?
                if user.webpay_oneclick_mall_user
                  user.webpay_oneclick_mall_user.update(token: init_subscription.token, mobile: true, subscribed: false)
                else
                  user.create_webpay_oneclick_mall_user(token: init_subscription.token, mobile: true)
                end
                args = { TBK_TOKEN: init_subscription.token }

                render json: { redirect_url: "#{init_subscription.url_webpay}?#{args.to_query}" }
              end
            end

            def unsubscribe
              if spree_current_user
                webpay_oneclick_mall_user = spree_current_user.webpay_oneclick_mall_user
                webpay_oneclick_mall_user.destroy
                unsubscribe = Tbk::WebpayOneclickMall::Subscription.new.remove_inscription(spree_current_user.id, webpay_oneclick_mall_user.tbk_user)
                render json: { success: true }
              else
                render json: { success: false, message: 'no user' }
              end
            rescue
              render json: { success: false, message: 'unexpected error' }
            end
          end
        end
      end
    end
  end
end