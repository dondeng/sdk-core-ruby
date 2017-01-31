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
    module Model
      ################################################################################
      # SmartMap
      ################################################################################

      class SmartMap

        KEY_LIST = "list"

        def initialize
          @properties = Hash.new
          @parentWithSquareBracket = /\[(.*)\]/
        end

        def set(key,value)
          #Sets the the value of key as value
          #Get the list of keys
          keys = key.split(".")

          #Number of keys
          keys_len = keys.length

          #Copy properties in sub properties so we can walk over it
          @subProperty = @properties

          count = 0

          keys.each do |part_key|
            count += 1

            #If we are at the final key, then we need to set this key for subProperty
            if count == keys_len
              match = @parentWithSquareBracket.match(part_key)
              #If match is nil then we can set the value
              if match.nil?
                @subProperty[part_key] = value
              else #if the key is like key[0]
                handleListTypeKeys(part_key,match,value)
              end
            else
              #walk inside subProperty
              createMap(part_key)
            end


          end

          return @properties

        end

        def get(key)
          #Gets the value from the map associated with the key

          #Sets the the value of key as value
          #Get the list of keys
          keys = key.split(".")

          #Number of keys
          keys_len = keys.length

          #Copy properties in sub properties so we can walk over it
          @subProperty = @properties

          count = 0

          keys.each do |part_key|
            count += 1
            #check if the key is of form key[0]
            match = @parentWithSquareBracket.match(part_key)

            #if the final key is of form key[0]
            unless match.nil?
              begin
                moveInList(part_key,match)
              rescue
                return nil
              end
              #If this is the last key
              if count == keys_len
                return @subProperty
              end
            else # Move in the map

              if @subProperty.is_a?(Hash) && @subProperty.key?(part_key)
                if count == keys_len #this is the final key, return the value
                  return @subProperty[part_key]
                else #Move in the map
                  @subProperty = @subProperty[part_key]
                end
              else
                return nil
              end

            end

          end

        end

        def setAll(map)

          #  Uses the hash object to create the base map object

          initialKey = ""

          #If given object is an array then the created map should have a key called list first

          if map.is_a?(Array)
            initialKey = KEY_LIST
          end

          #Iterate over the object and keeps on adding the items to the properties object
          iterateItemsAndAdd(map,initialKey)

          return @properties


        end



        def getObject
          #Returns the basemap internal object
          return @properties
        end

        def size
          #
          #Returns the number of keys at the first level of the object
          #
          return @properties.length
        end

        def containsKeys(key)

          #checks if map contains the key

          unless get(key).nil?
            return true
          end

          return false

        end


        private

        def createMap(key)

          match = @parentWithSquareBracket.match(key)
          #If it is not a type of key[0]
          if match.nil?

            unless @subProperty.is_a?(Hash) && @subProperty.key?(key)

                if @subProperty.is_a?(Hash)
                  @subProperty[key] = Hash.new
                else
                  raise KeyError.new("Invalid Key String : Cannot override value #{@subProperty}")
                end
            end
            @subProperty = @subProperty[key]

          else
            handleListTypeKeys(key,match,{})
          end

        end

        def iterateItemsAndAdd(map,combKey)

          #Iterate over the items in the map object and adds them to basemap object

          #The implementation is more of a depth first search
          #For a given object for eg {"user":"name":{"first":"naman","last":"aggarwal",roll:[4,3,6]}}
          #It reaches to a lowest level and keeps track of the key, in this case user.name.first and then
          #uses set function to set the value set("user.name.first","naman")
          #For list it uses index as keys, for eg user.name.roll[0] = 4

          #Check if it object is  a hash
          if map.is_a?(Hash)
            map.each do |key,value|
              #if last combined is not empty then append current key to it else use current key
              tempKey = if combKey!= "" then "#{combKey}.#{key}" else key end
              #call the function again with one level down and combined key
              iterateItemsAndAdd(map[key],tempKey)

            end
          #If the object is an Array , for eg roll:[1,2,3] (combKey will be user.name for this case)
          elsif map.is_a?(Array)
            count = 0
            # Iterate over each value
            map.each do |value|
              #create the temp key with the current index
              tempKey = "#{combKey}[#{count.to_s}]"
              #call the function again with one level lower and combined key
              iterateItemsAndAdd(value,tempKey)
              count+=1
            end
          #If its any other object then set the key to that value
          else

            set(combKey,map)
          end

        end


        def handleListTypeKeys(key,match,value)
          #Handles the keys of type key[0]

          #Creates a new list if key does not exist else moves to keys
          #Adds the value at the poistion index for key[index]
          #if index == len of list then appends
          #if index > len then throw exception

          #Get the array index (should be the first matched group)
          arr_key = match[1]

          #Get the text key
          txt_key = key[0...match.begin(0)]

          begin
            arr_key = Integer(arr_key)
          rescue ArgumentError
            raise KeyError.new("Key #{arr_key.to_s} is not an integer")
          end

          #If txt_key not in subProperty
          unless @subProperty.key?(txt_key)
            #If the arr_key is not integer or not zero
            if arr_key != 0
              raise KeyError.new("Key #{match[0]} is invalid")
            end

            #add key as a list
            @subProperty[txt_key] = Array.new

            #walk the subProperty into it
            @subProperty = @subProperty[txt_key]

            #Append the value
            @subProperty.push(value)

            #move into the array
            @subProperty = @subProperty[arr_key]

          else #If the text key exist in the map

            #move in the map
            @subProperty = @subProperty[txt_key]

            if arr_key < @subProperty.length
              if value == {} #If the value is {} then we just want to move in the hash
                @subProperty = @subProperty[arr_key]
              else # This means that this is the last key and value need to be set
                @subProperty[arr_key] = value
              end
            #This means that index arr_key does not exist in the list
            #If the index is same as length then append
            elsif @subProperty.length == arr_key

              @subProperty.push(value)

              #move inside the array
              @subProperty = @subProperty[arr_key]

            else
              raise KeyError.new("Key #{match[0]} is invalid")
            end

          end

        end

        def moveInList(key, match)
          #Moves in the subMap, if key is of type for eg key[1] and match matches [1]
          #Raises exception if either key is not in map or map.key is not a list or map.key[1] does not exist

          #Get the array index (should be the first matched group)
          arr_key = match[1]

          #Get the text key
          txt_key = key[0...match.begin(0)]

          begin
            arr_key = Integer(arr_key)
          rescue ArgumentError
            raise KeyError.new("Key #{arr_key.to_s} is not an integer")
          end

          unless @subProperty.key?(txt_key)
            raise KeyError.new("Key #{match[0]} is not valid")
          end

          #move inside
          @subProperty = @subProperty[txt_key]

          if @subProperty.is_a?(Array) && arr_key < @subProperty.length
            #If list and list index exists then move to the index
            @subProperty = @subProperty[arr_key]
          else
            raise KeyError.new("Invalid key index #{arr_key.to_s}")
          end

        end



      end
      
      ################################################################################
      # OperationMetadata
      ################################################################################

      class OperationMetadata
       
        def initialize(version, host, context = nil)
          @version = version
          @host = host
          @context = context
        end
        
        def getVersion()
          return @version
        end
        
        def getHost()
          return @host
        end
        
        def getContext()
          return @context
        end
       
      end
      
      
      ################################################################################
      # OperationConfig
      ################################################################################

      class OperationConfig
       
        def initialize(resourcePath, action, headerParams, queryParams)
          @resourcePath = resourcePath
          @action = action
          @headerParams = headerParams
          @queryParams = queryParams
        end
        
        def getResoucePath()
           return @resourcePath
        end
        
        def getAction()
          return @action
        end
        
        def getHeaderParams()
          return @headerParams
        end
        
        def getQueryParams()
          return @queryParams
        end
        
      end

      ################################################################################
      # RequestMap
      ################################################################################

      class RequestMap < SmartMap
        def initialize
          #call the base class constructor
          super()
        end
      end

      


    end
  end
end
