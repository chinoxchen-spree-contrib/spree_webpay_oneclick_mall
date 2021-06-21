module Spree
  module OrderDecorator
    # Indica si la orden tiene algun pago con Webpay completado con exito
    #
    # Return TrueClass||FalseClass instance
    def oneclick_mall_payment_completed?
      if payments.completed.from_oneclick_mall.any?
        true
      else
        false
      end
    end

    def webpay_client_name
      if ship_address
        ship_address.full_name
      else
        "#{user.firstname} #{user.lastname}"
      end
    end


    # Indica si la orden tiene asociado un pago por Webpay
    #
    # Return TrueClass||FalseClass instance
    def has_oneclick_mall_payment_method?
      payments.valid.from_oneclick_mall.any?
    end

    # Devuelvela forma de pago asociada a la order, se extrae desde el ultimo payment
    #
    # Return Spree::PaymentMethod||NilClass instance
    def oneclick_mall_payment_method
      has_oneclick_mall_payment_method? ? payments.valid.from_oneclick_mall.order(:id).last.payment_method : nil
    end

    # Entrega en valor total en un formato compatible con el estandar de Webpay
    #
    # Return String instance
    def webpay_amount
      total.to_i
    end
  end
end

::Spree::Order.prepend Spree::OrderDecorator