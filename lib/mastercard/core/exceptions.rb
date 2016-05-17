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
        def initialize(message,status=nil, error_data=nil)
          #Call the base class constructor
          super(message)

          @message    = message
          @status     = status
          @error_data = error_data
          @error_code = nil

          #If error_data is not nil set the appropriate message
          unless error_data.nil?

            error_hash = Hash.new
            # If error_data is of type hash and has Key 'Errors' which has a key 'Error'
            if error_data.is_a?(Hash) && error_data.key?("Errors") && error_data["Errors"].key?("Error")

              error_hash = error_data["Errors"]["Error"]

              #Case of multiple errors take the first one
              if error_hash.is_a?(Array)
                error_hash = error_hash[0]
              end

              initDataFromHash(error_hash)

            #If error Data is of Type Array
            elsif error_data.is_a?(Array)
              #Take the first error
              error_hash = error_data[0]
              initDataFromHash(error_hash)
            end
          end

        end

        def getMessage()
          return @message
        end

        def getStatus()
          return @status
        end

        def getErrorCode()
          return @error_code
        end

        def getErrorData()
          return @error_data
        end

        def describe()
          exception = self.class.name
          exception << ": \""
          exception << getMessage()
          exception << "\" (status: "
          exception << "%s" % getStatus()
          errorCode = getErrorCode()
          unless errorCode.nil?
            exception << ", error code: "
            exception << "%s" % getErrorCode()
          end
          exception << ")"
          return exception
        end

        def to_s()
          return '%s' % describe()
        end

        private

        def initDataFromHash(error_hash)
          @error_code = error_hash.fetch("ReasonCode","")
          @message    = error_hash.fetch("Message",@message)
        end

      end

      ################################################################################
      # ApiConnectionException
      ################################################################################

      class APIConnectionException < APIException
        #
        #Exception raised when there are communication problems contacting the API.
        def initialize(message=nil,status=nil,error_data=nil)


          if status.nil?
              status = 500
          end

          #Call the base class constructor
          super(message,status,error_data)
        end
      end


      ################################################################################
      # ObjectNotFoundException
      ################################################################################

      class ObjectNotFoundException < APIException
        #
        #Exception raised when the endpoint does not exist.
        def initialize(message=nil,status=nil,error_data=nil)


          if status.nil?
              status = 404
          end

          #Call the base class constructor
          super(message,status,error_data)
        end
      end

      ################################################################################
      # AuthenticationException
      ################################################################################

      class AuthenticationException < APIException
        #
        #Exception raised where there are problems authenticating a request.
        def initialize(message=nil,status=nil,error_data=nil)


          if status.nil?
              status = 401
          end

          #Call the base class constructor
          super(message,status,error_data)
        end
      end

      ################################################################################
      # InvalidRequestException
      ################################################################################

      class InvalidRequestException < APIException
        #
        #Exception raised when the API request contains errors.

        def initialize(message=nil,status=nil,error_data=nil)

          if status.nil?
              status = 400
          end

          #Call the base class constructor
          super(message,status,error_data)

          @fieldErrors = []

          #If error_data is not nil set the appropriate message
          unless error_data.nil?

            error_hash = Hash.new
            # If error_data is of type hash and has Key 'Errors' which has a key 'Error'
            if error_data.is_a?(Hash) && error_data.key?("Errors") && error_data["Errors"].key?("Error")

              error_hash = error_data["Errors"]["Error"]

              #Case of multiple errors take the first one
              if error_hash.is_a?(Array)
                error_hash = error_hash[0]
              end

              initFieldDataFromHash(error_hash)

            #If error Data is of Type Array
            elsif error_data.is_a?(Array)
              #Take the first error
              error_hash = error_data[0]
              initFieldDataFromHash(error_hash)
            end
          end
        end


        def hasFieldErrors
          return @fieldErrors.length != 0
        end

        def getFieldErrors
          return @fieldErrors
        end

        def describe
          des = super()
          @fieldErrors.each do |field_error|
            des << "\n #{field_error}"
          end
          return des
        end

        def to_s
          return "%s"%describe()
        end

        private

        def initFieldDataFromHash(error_hash)
          if error_hash.key?("FieldErrors")
            error_hash.fetch("FieldErrors").each do |field_error|
              @fieldErrors << "%s"%FieldError.new(field_error)
            end
          end
        end



      end

      ################################################################################
      # NotAllowedException
      ################################################################################

      class NotAllowedException < APIException
        #
        #Exception when a request was not allowed.
        def initialize(message=nil,status=nil,error_data=nil)


          if status.nil?
              status = 403
          end

          #Call the base class constructor
          super(message,status,error_data)

        end
      end


      ################################################################################
      # SystemException
      ################################################################################

      class SystemException < APIException
        #
        #Exception when there was a system error processing a request.
        def initialize(message=nil,status=nil,error_data=nil)


          if status.nil?
              status = 500
          end

          #Call the base class constructor
          super(message,status,error_data)
        end
      end

      ################################################################################
      # FieldError
      ################################################################################

      class FieldError

        def initialize(params)

          @name    = params.fetch("field","")
          @message = params.fetch("message","")
          @code    = params.fetch("code")
        end

        def getFieldName
          return @name
        end

        def getErrorMessage
          return @message
        end

        def getErrorCode
          return @code
        end

        def to_s
          return "Field Error: #{@name} \"#{@message}\" (#{@code})"
        end
      end

    end
  end
end
