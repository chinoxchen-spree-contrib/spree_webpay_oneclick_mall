# frozen_string_literal: true
module Tbk
  module WebpayOneclickMall
    class TbkLogger

      def initialize(*args)
        @args = args
      end

      def logger
        Logger.new(self.class.path)
      end

      def self.path
        if Rails.env.test?
          "#{Rails.root}/log/webpay_oneclick_mall_test.log"
        else
          "#{Rails.root}/log/webpay_oneclick_mall.log"
        end
      end

      def log_info(action, content)
        exec_log_info(@args.any? ? "[#{@args.join(":")}]" : nil, action, content)
      end

      def log_error(action, content)
        exec_log_error(@args.any? ? "[#{@args.join(":")}]" : nil, action, content)
      end

      private
      def exec_log_info(id, action, content)
        logger.info("#{id} #{action} #{content}")
      end

      def exec_log_error(id, action, content)
        logger.error("#{id} #{action} #{content}")
      end
    end

  end
end