module Spree
  module Api
    module V2
      module Storefront
        module Account
          class OneclickMallPaymentController < ::Spree::Api::V2::ResourceController
            include Spree::Api::V2::Storefront::OrderConcern
            before_action :ensure_order

            def pay_with_webpay_oneclick_mall
              @order = spree_current_order
              unless @order.present?
                render json: { success: false, message: 'no order found' }, state: 404
                return
              end
              payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall').first
              payment = oneclick_create_payment(payment_method)
              pay(payment_method, payment)
            end

            def oneclick_create_payment(payment_method)
              payment = @order.payments.build(payment_method_id: payment_method.id, amount: @order.total, state: 'checkout')

              unless payment.save
                render json: { success: false, message: payment.errors.full_messages.join("\n") }
                return
              end

              unless payment.pend!
                render json: { success: false, message: payment.errors.full_messages.join("\n") }
                return
              end
              return payment
            end

            def pay(payment_method, payment)
              unless @order.user && @order.user.webpay_oneclick_mall_user && @order.user.webpay_oneclick_mall_user.subscribed?
                redirect_to oneclick_mall_subscription_path and return
              end

              provider = payment_method.provider.new
              amount  = @order.webpay_amount
              user = @order.user
              oneclick_user = user.webpay_oneclick_mall_user
              shares_number = 0
              oneclick_authotize = provider.authorize(user.id,
                oneclick_user.tbk_user,
                @order.number,
                @order.webpay_amount,
                shares_number,
                payment.number)

              if oneclick_authotize.details.first['status'] == 'AUTHORIZED' && oneclick_authotize.details.first['response_code'].zero?
                payment.complete!
                @order.skip_stock_validation = true
                @order.next! unless @order.state == "completed"

                render json: { success: true }
                return
              else
                payment.failure!
                render json: { success: false }
                return
              end
            rescue StandardError => e
              oneclick_error(e)
            end

            def oneclick_error(e = nil)
              render json: { success: false, message: "oneclick error #{e.try(:message)}" }
              return
            end
          end
        end
      end
    end
  end
end