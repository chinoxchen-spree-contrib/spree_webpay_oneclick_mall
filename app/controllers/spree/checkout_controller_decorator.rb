module Spree::CheckoutControllerDecorator
  def self.prepended(base)
    base.before_action :pay_with_webpay_oneclick_mall, only: :update
  end

  private

  def pay_with_webpay_oneclick_mall
    return unless params[:state] == 'payment'
    return if params[:order].blank? || params[:order][:payments_attributes].blank?

    pm_id = params[:order][:payments_attributes].first[:payment_method_id]
    payment_method = Spree::PaymentMethod.find(pm_id)

    unless @order.user && @order.user.webpay_oneclick_mall_user && @order.user.webpay_oneclick_mall_user.subscribed?
      redirect_to oneclick_mall_subscription_path and return
    end

    if payment_method && payment_method.kind_of?(Spree::PaymentMethod::WebpayOneclickMall)
      oneclick_create_payment(payment_method)
      redirect_to oneclick_mall_pay_path(permitted_params) and return
    end
  end

  def oneclick_create_payment(payment_method)
    payment = @order.payments.build(payment_method_id: payment_method.id, amount: @order.total, state: 'checkout')

    unless payment.save
      flash[:error] = payment.errors.full_messages.join("\n")
      redirect_to checkout_state_path(@order.state) && return
    end

    unless payment.pend!
      flash[:error] = payment.errors.full_messages.join("\n")
      redirect_to checkout_state_path(@order.state) && return
    end
  end

  def permitted_params
    params.permit!
  end
end

Spree::CheckoutController.prepend Spree::CheckoutControllerDecorator

