require "mastercard/core/constants"

module MasterCard
  module Core
    module Config
      class Config
        include MasterCard::Core::Constants

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
            return API_BASE_LOCALHOST_URL
          elsif @@sandbox
            return API_BASE_SANDBOX_URL
          end

          return API_BASE_LIVE_URL
        end



      end
    end
  end
end
