require "mastercard/core/constants"

module MasterCard
  module Core
    class Config

      private
      @@sandbox = true
      @@debug   = false
      @@authentication = nil
      @@localhost  = false

      public
      def self.setDebug(debug)
        @@debug = debug
      end

      def self.getDebug()
        return @@debug
      end

      def self.setSandbox(sandbox)
        @@sandbox = sandbox
      end

      def self.getSandbox()
        return @@sandbox
      end

      def self.setLocal(local)
        @@localhost = local
      end

      def self.getLocal
        return @@localhost
      end

      def self.setAuthentication(auth)
        @@authentication = auth
      end

      def self.getAuthentication
        return @@authentication
      end

      def self.getAPIBaseURL

        if @@localhost
          return Constants::API_BASE_LOCALHOST_URL
        elsif @@sandbox
          return Constants::API_BASE_SANDBOX_URL
        end

        return Constants::API_BASE_LIVE_URL
      end
    end
  end
end
