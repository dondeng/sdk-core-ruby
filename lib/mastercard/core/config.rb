#
# Copyright (c) 2016 MasterCard International Incorporated
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list of
# conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright notice, this list of
# conditions and the following disclaimer in the documentation and/or other materials
# provided with the distribution.
# Neither the name of the MasterCard International Incorporated nor the names of its
# contributors may be used to endorse or promote products derived from this software
# without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
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

      def self.isDebug()
        return @@debug
      end

      def self.setSandbox(sandbox)
        @@sandbox = sandbox
      end

      def self.isSandbox()
        return @@sandbox
      end

      def self.setLocal(local)
        @@localhost = local
      end

      def self.isLocal
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
