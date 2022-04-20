module Spree
  module Api
    module V2
      module Storefront
        module Account
          class OneclickMallV2PaymentController < ::Spree::Api::V2::ResourceController
            include Spree::Api::V2::Storefront::OrderConcern
            before_action :ensure_order, except: [:order_status]

            def pay_with_webpay_oneclick_mall
              @order = spree_current_order
              unless @order.present?
                render json: { success: false, message: 'no order found' }, state: 404
                return
              end
              payment_method = Spree::PaymentMethod.where(type: 'Spree::PaymentMethod::WebpayOneclickMall').first
              oneclick_create_payment(payment_method)

              if pay(payment_method)
                render json: { success: true, message: @response }
              else
                render json: { success: false, message: @response }
              end

            rescue StandardError => e
              oneclick_error(e)
            end

            def order_status
              if params[:order_number].blank?
                render json: { success: false, message: 'no order found' }, state: 404
                return
              end
              @order = Spree::Order.find_by(number: params[:order_number])

              if @order.blank?
                render json: { success: false, message: 'no order found' }, state: 404
                return
              end

              render json: { success: true, message: @order.state }
            end

            def oneclick_create_payment(payment_method)
              @payment = @order.payments.build(payment_method_id: payment_method.id, amount: @order.total, state: 'checkout')

              unless @payment.save
                raise 'cant create payment ' + @payment.errors.full_messages.join("\n")
              end

              unless @payment.pend!
                raise 'cant create pend ' + @payment.errors.full_messages.join("\n")
              end
            end

            def pay(payment_method)
              unless @order.user && @order.user.webpay_oneclick_mall_user && @order.user.webpay_oneclick_mall_user.subscribed?
                redirect_to oneclick_mall_subscription_path and return
              end

              provider            = payment_method.provider.new
              amount              = @order.webpay_amount
              user                = @order.user
              oneclick_user       = user.webpay_oneclick_mall_user
              shares_number       = 1
              oneclick_authotize  = provider.authorize(user.id,
                oneclick_user.tbk_user,
                @order.number,
                @order.webpay_amount,
                shares_number,
                @payment.number)

              @response = oneclick_authotize.details

              if oneclick_authotize.details.first['status'] == 'AUTHORIZED' && oneclick_authotize.details.first['response_code'].zero?
                if !@payment.completed?
                  ConfirmPaymentJob.perform_later(@payment)
                end
                return true
              else
                @payment.update_column(:response_code, oneclick_authotize.details.first['response_code'].to_s)
                @payment.failure!
                return false
              end
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