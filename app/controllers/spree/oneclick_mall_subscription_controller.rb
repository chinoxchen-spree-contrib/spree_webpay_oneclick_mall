module Spree
  class OneclickMallSubscriptionController < StoreController
    skip_before_action :verify_authenticity_token


    def subscription; end

    def subscribe
      user = try_spree_current_user
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
          user.webpay_oneclick_mall_user.update(token: init_subscription.token, subscribed: false, mobile: false)
        else
          user.create_webpay_oneclick_mall_user(token: init_subscription.token, mobile: false)
        end
        args = { TBK_TOKEN: init_subscription.token }

        set_back_url(params[:subscribe])
        redirect_to "#{init_subscription.url_webpay}?#{args.to_query}"
      end
    end

    def m_subscribe_failure
      render layout: false
    end

    def m_subscribe_success
      render layout: false
    end

    def subscribe_confirmation
      oneclick_user = Tbk::WebpayOneclickMall::User.find_by(token: params["TBK_TOKEN"])
      if oneclick_user
        finish_inscription = Tbk::WebpayOneclickMall::Subscription.new.finish_inscription(params["TBK_TOKEN"])

        if finish_inscription.response_code.zero?
          oneclick_user.update(
            subscribed: true,
            tbk_user: finish_inscription.tbk_user,
            authorization_code: finish_inscription.authorization_code,
            card_type: finish_inscription.card_type,
            card_number: finish_inscription.card_number
          )

          if oneclick_user.mobile?
            redirect_to oneclick_mall_m_subscribe_success_path
          else
            redirect_to oneclick_mall_subscribe_success_path
          end
        else
          if oneclick_user.mobile?
            redirect_to oneclick_mall_m_subscribe_failure_path
          else
            redirect_to oneclick_mall_subscribe_failure_path
          end
        end
      else
        raise(ActiveRecord::RecordNotFound)
      end
    end

    def unsubscribe
      set_back_url(params)
      if try_spree_current_user
        webpay_oneclick_mall_user = try_spree_current_user.webpay_oneclick_mall_user
        webpay_oneclick_mall_user.destroy
        unsubscribe = Tbk::WebpayOneclickMall::Subscription.new.remove_inscription(try_spree_current_user.id, webpay_oneclick_mall_user.tbk_user)
        render :unsubscribed
      else
        redirect_to root_path and return
      end
    rescue
      render :unsubscribed
    end

    def set_back_url(params)
      cookies[:back_url_oneclick] = params.present? && params[:back_url].present? ? params[:back_url] : checkout_state_path(:payment)
      if cookies[:back_url_oneclick].include? 'unsubscribe'
        cookies[:back_url_oneclick] = root_path
      end
    end
  end
end
