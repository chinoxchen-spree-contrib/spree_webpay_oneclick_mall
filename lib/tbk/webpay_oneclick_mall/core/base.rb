# frozen_string_literal: true
module Tbk::WebpayOneclickMall::Core
  class Base
    attr_reader :response, :action

    def self.call(*args)
      new(*args).call
    end

    def initialize(*_options)
      certificates_and_key
      @id = SecureRandom.hex(10)
      @action = self.class.name.demodulize.snakecase.to_sym
      @logger = Tbk::WebpayOneclickMall::TbkLogger.new(@id)
      @commerce_codes =  WebpayOneclickMallConfig::COMMERCE_CODE
    end

    def call
      if @response.nil?
        request = client.build_request(action, message: payload)
        log_request
        signed_xml = MessageSigner.call(
          request.body,
          @public_certificate,
          @private_key
        )

        begin
          @response = client.call(action) do
            xml signed_xml.to_xml(save_with: 0)
          end
          log_response
        rescue Savon::SOAPFault => e
          log_error e
        end
      end
      @response
    end

    def client
      @client ||= Savon.client(wsdl: WebpayOneclickMallConfig::ENDPOINT)
    end

    def response_body(full = false)
      if full
        (@response || call).body
      else
        (@response || call).body["#{@action}_response".to_sym][:return]
      end
    end

    def details
      response_body
    end

    def details_params
      {
        action.to_s => details.to_json
      }
    end


    private

    def certificates_and_key
      @commerce_code =  WebpayOneclickMallConfig::COMMERCE_CODE
      @mall_code =  WebpayOneclickMallConfig::MALL_CODE
      @private_key = OpenSSL::PKey::RSA.new(File.read(WebpayOneclickMallConfig::CLIENT_PRIVATE_KEY))
      @public_certificate = OpenSSL::X509::Certificate.new(
        File.read( WebpayOneclickMallConfig::CLIENT_CERTIFICATE)
      )
    end

    def log_request_data
      [
        "webpay",
        "id: #{@id}",
        "action: #{action}",
        "type: request",
        "payload: #{payload}",
      ].join(" | ")
    end

    def log_response_data
      [
        "webpay",
        "id: #{@id}",
        "action: #{action}",
        "type: response",
        "payload: #{payload}",
        "response: #{@response.try(:body)}"
      ].join(" | ")
    end

    def log_request
      @logger.log_info(action, log_request_data)
    end

    def log_response
      @logger.log_info(action, log_response_data)
    end

    def log_error(error)
      @logger.log_error(action, error.backtrace.join("\n"))
    end

    def payload
      raise "You need to redefine this method"
    end

  end
end
