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
module MasterCard
  module Core
    module Exceptions

      ################################################################################
      # APIException
      ################################################################################
      class APIException  < StandardError
        #
        # Base Class for all the API exceptions
        def initialize(message,http_status=nil, error_data=nil)
          #Call the base class constructor
          super(message)

          @message    = message
          @http_status     = http_status
          @raw_error_data = error_data
          @reason_code = nil
          @source = nil
          @description = nil

          #If error_data is not nil set the appropriate message
          unless error_data.nil?

            @raw_error_data = error_data

            error_data_case_insensitive = parseMap(error_data)

            # If error_data is of type hash and has Key 'Errors' which has a key 'Error'
            if error_data_case_insensitive.key?("errors") && error_data_case_insensitive["errors"].key?("error")
              error_hash = error_data_case_insensitive["errors"]["error"]

              #Case of multiple errors take the first one
              if error_hash.is_a?(Hash)
                initDataFromHash(error_hash)

              #If error Data is of Type Array
              elsif error_hash.is_a?(Array)
                #Take the first error
                error_hash = error_hash[0]
                initDataFromHash(error_hash)
              end
            end
          end
        end

        def getMessage()
          if @description.nil?
            return @message
          else
            return @description
          end
        end

        def getHttpStatus()
          return @http_status
        end

        def getReasonCode()
          return @reason_code
        end

        def getSource()
          return @source
        end

        def getRawErrorData()
          return @raw_error_data
        end

        def describe()
          exception = self.class.name
          exception << ": \""
          exception << getMessage()
          exception << "\" (http_status: "
          exception << "%s" % getHttpStatus()
          errorCode = getReasonCode()
          unless errorCode.nil?
            exception << ", reason_code: "
            exception << "%s" % getReasonCode()
          end
          exception << ")"
          return exception
        end

        def to_s()
          return '%s' % describe()
        end

        private

        def initDataFromHash(error_hash)
          @reason_code  = error_hash.fetch("reasoncode",nil)
          @description      = error_hash.fetch("description",@message)
          @source       = error_hash.fetch("source",nil)
        end

        def parseMap(map)
          parsedMap = {}
          map.each do |k, v|
            if v.is_a?(Array)
              parsedMap[k.to_s.downcase] = parseList(v)
            elsif v.is_a?(Hash)
              parsedMap[k.to_s.downcase] = parseMap(v)
            else
              parsedMap[k.to_s.downcase] = v
            end
          end
          return parsedMap
        end

        def parseList(l)
          parsedList = []
          l.each do |v|
            if v.is_a?(Array)
              parsedList << parseList(v) 
            elsif v.is_a?(Hash)
              parsedList << parseMap(v)
            else
              parsedList << v
            end
          end
          return parsedList
        end

      end
    end
  end
end
