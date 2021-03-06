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
      @@debug   = false
      @@environment = Environment::SANDBOX
      @@authentication = nil;
      @@registeredInstances = {}

      public
      def self.setDebug(debug)
        @@debug = debug
      end

      def self.isDebug()
        return @@debug
      end

      def self.setSandbox(sandbox)
        if sandbox
          @@registeredInstances.values().each { |instance| instance.setEnvironment(Environment::SANDBOX) }
          @@environment = Environment::SANDBOX
        else
          @@registeredInstances.values().each { |instance| instance.setEnvironment(Environment::PRODUCTION) }
          @@environment = Environment::PRODUCTION
        end
      end
      
      def self.isSandbox
        return @@environment == Environment::SANDBOX
      end


      def self.getEnvironment
        return @@environment
      end
      
      def self.setEnvironment(environment)

        if !environment.nil? && !environment.empty?
          if Environment::MAPPING.key?(environment)
            @@registeredInstances.values().each { |instance| instance.setEnvironment(environment) }
            @@environment = environment
          end
        end
      end


      def self.setAuthentication(auth)
        @@authentication = auth
      end

      def self.getAuthentication
        return @@authentication
      end

      def self.registerResourceConfig(instance)
        if !@@registeredInstances.key?(instance.class.name)
          @@registeredInstances[instance.class.name] = instance
        end
      end

      def self.clearResourceConfig
        @@registeredInstances = {}
      end

      def self.sizeResourceConfig
         return @@registeredInstances.length
      end

    end
  end
end
