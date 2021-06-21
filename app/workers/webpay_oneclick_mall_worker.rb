class WebpayOneclickMallWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  sidekiq_options :queue => :webpay

  def perform payment_id, state
    puts "#{payment_id} - #{state}"
    payment = Spree::Payment.find payment_id
    return unless payment
    order = payment.order
    puts "Completing order #{order.number}"
    begin
      if state == "accepted"
        payment.started_processing!
        payment.capture!
        order.next! unless order.state == "completed"
        puts "Completed order #{order.number}"
      elsif state == "rejected"
        payment.started_processing!
        payment.failure!
        puts "Failed order #{order.number}"
      end
    rescue Exception => e
      Rails.logger.error("Error al procesar pago orden #{order.number}: E -> #{e.message}")
    end
  end

end