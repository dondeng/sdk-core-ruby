require "mastercard/core/controller"
require "mastercard/core/model"

module MasterCard
  module Core
    module Model      
      ################################################################################
      # BaseObject
      ################################################################################

      class BaseObject < RequestMap
        include MasterCard::Core::Controller
        include MasterCard::Core::Model

        def initialize(requestMap = nil)

          #call the base class constructor
          super()

          unless requestMap.nil?
            setAll(requestMap.getObject())
          end

        end


        protected
        
        def self.getOperationConfig(uuid)
          raise NotImplementedError.new("Child class must define getOperationConfig method to use this class")
        end

        def self.getOperationMetadata()
          raise NotImplementedError.new("Child class must define getOperationMetadata method to use this class")
        end
        
        def self.execute(operationUUID,inputObject)
          
          
          config = inputObject.class.getOperationConfig(operationUUID)
          metadata = inputObject.class.getOperationMetadata()

          response = APIController.new.execute(config,metadata,inputObject.getObject())
          returnObjClass = inputObject.class

          if config.getAction().upcase == APIController::ACTION_LIST
            returnObj = []

            if response.is_a?(Hash) && response.key?(RequestMap::KEY_LIST)
              response = response[RequestMap::KEY_LIST]
            end

            if response.is_a?(Hash)

              response.each do |key,value|

                requestMap = RequestMap.new
                requestMap.setAll(value)
                returnObj.push(returnObjClass.new(requestMap))

              end

            elsif response.is_a?(Array)

              response.each do |value|
                requestMap = RequestMap.new
                requestMap.setAll(value)
                returnObj.push(returnObjClass.new(requestMap))

              end

            end
            return returnObj
          else

            requestMap = RequestMap.new
            requestMap.setAll(response)
            return returnObjClass.new(requestMap)

          end

        end

      end
    end
  end
end