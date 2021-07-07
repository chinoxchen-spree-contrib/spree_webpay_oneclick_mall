module Spree
  class OneclickMallPaymentController < StoreController

    skip_before_action :verify_authenticity_token

    before_action :load_data, only: :pay

    def pay
      unless @order.user && @order.user.webpay_oneclick_mall_user && @order.user.webpay_oneclick_mall_user.subscribed?
        redirect_to oneclick_mall_subscription_path and return
      end

      payment_method = @payment.payment_method
      provider = payment_method.provider.new
      amount  = @order.webpay_amount
      user = @order.user
      oneclick_user = user.webpay_oneclick_mall_user
      shares_number = 1
      oneclick_authotize = provider.authorize(user.id,
                                              oneclick_user.tbk_user,
                                              @order.number,
                                              @order.webpay_amount,
                                              shares_number,
                                              @payment.number)

      if oneclick_authotize.details.first['status'] == 'AUTHORIZED' && oneclick_authotize.details.first['response_code'].zero?
        @payment.complete!
        @order.skip_stock_validation = true
        @order.next! unless @order.state == "completed"

        redirect_to oneclick_mall_success_path({payment_number: @payment.number}) and return
      else
        @payment.failure!
        redirect_to oneclick_mall_failure_path({payment_number: @payment.number}), alert: I18n.t('payment.transaction_error') and return
      end
    rescue StandardError => e
      oneclick_error(e)
    end

    def success
      @payment = Spree::Payment.find_by!(number: params[:payment_number])
      @order = @payment.order
      session[:order_id] = nil
      @current_order     = nil

      redirect_to root_path and return if @payment.blank?

      if @payment.failed? || !@payment.completed?
        # reviso si el pago esta fallido y lo envio a la vista correcta
        redirect_to oneclick_mall_failure_path(params) and return
      else
        if @order.completed? || @payment.completed?

          unless OneclickNotification.find_by(order_id: @payment.order_id, payment_id: @payment.id)
            flash.notice = Spree.t(:order_processed_successfully)
            flash['order_completed'] = true
          end

          OneclickNotification.create(order_id: @payment.order_id, payment_id: @payment.id)

          redirect_to completion_route and return
        else
          redirect_to oneclick_mall_failure_path(params) and return
        end

      end
    end

    def failure
      @rejected = params[:rejected]=="true"
    end

    def oneclick_error(e = nil)
      flash[:error] = "oneclick error #{e.try(:message)}"
      redirect_to checkout_state_path(@order.state)
      return
    end

    private

    def load_data
      @order = current_order || raise(ActiveRecord::RecordNotFound)
      @payment = @order.payments.order(:id).last
    end

    def completion_route
      spree.order_path(@order)
    end
  end
end
