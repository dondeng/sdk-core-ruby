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
require 'mastercard/core/config'
require 'mastercard/core/exceptions'
require 'mastercard/core/util'
require 'mastercard/security/authentication'
require 'net/http'
require 'json'

module MasterCard
  module Core
    module Controller
      class APIController
        include MasterCard::Core
        include MasterCard::Core::Exceptions
        include MasterCard::Security

        ACTION_CREATE = "CREATE"
        ACTION_DELETE = "DELETE"
        ACTION_UPDATE = "UPDATE"
        ACTION_READ   = "READ"
        ACTION_LIST   = "LIST"
        ACTION_QUERY  = "QUERY"

        KEY_ID     = "id"
        KEY_FORMAT = "Format"
        KEY_ACCEPT = "Accept"
        KEY_USER_AGENT = "User-Agent"
        KEY_CONTENT_TYPE = "Content-Type"
        APPLICATION_JSON = "application/json"
        RUBY_SDK       = "Ruby_SDK"
        JSON_STR       = "JSON"


        def execute(config,metadata,input)
          
          #Check preconditions for execute
          preCheck()
          
          resolvedHost = metadata.getHost()
          if resolvedHost != nil && resolvedHost != 0
            unless Util.validateURL(resolvedHost)
              raise APIException.new "URL: '" + resolvedHost + "' is not a valid url"
            end
          else
            raise APIException.new "URL: '' is not a valid url"
          end

          
          uri = URI.parse(resolvedHost)
          #Get the http object
          http = getHTTPObject(uri)
          
          #Get the request Object
          request = getRequestObject(config,metadata,input)

          if Config.isDebug
            puts "---- Request ----"
            puts ""
            puts "URL"
            puts request.path
            puts ""
            puts "Headers"
            request.each_header do |header_name, header_value|
              puts "#{header_name} : #{header_value}"
            end
            puts ""
            puts "Body"
            puts request.body
          end

          begin
            response = http.request(request)

            if Config.isDebug
              puts "---- Response ----"
              puts ""
              puts "Status Code"
              puts response.code
              puts ""
              puts "Headers"
              response.each_header do |header_name, header_value|
                puts "#{header_name} : #{header_value}"
              end
              puts ""
              puts "Body"
              puts response.body
            end


            return handleResponse(response,response.body)
          rescue Errno::ECONNREFUSED
            raise APIException.new ("Connection to server could not be established.")
          end


        end


        private


        def handleResponse(response,content)
          #Handles the exception and response
          status = response.code.to_i

          if content
            begin
              content = JSON.load content
            rescue JSON::ParserError
            end
          end

          if 200 <= status && status <= 299
            return content
          else 
            raise APIException.new("Operation not allowed",status,content)
          end

        end

        def getBody(action,input)
          #Returns the body hash depending on action
          body = nil
          case action.upcase
          when ACTION_CREATE, ACTION_UPDATE
            unless input.nil?
              body = input
            end
          end
          return body
        end

        def getPathParams(action,queryParams,input)
          #Returns the path params based on action
          pathParams = {KEY_FORMAT => JSON_STR}
          case action.upcase
          when ACTION_LIST, ACTION_READ, ACTION_QUERY, ACTION_DELETE
            unless input.nil?
              pathParams = pathParams.merge(input)
            end
          end

          #merge the queryParams
          pathParams = pathParams.merge(queryParams)

          return pathParams
        end

        def getHTTPObject(uri)
          
          #Returns the HTTP Object
          http = Net::HTTP.new(uri.host,uri.port)
          
          if uri.scheme ==  "https"
            http.use_ssl = true
          end

          return http

        end

        def encode_path_params(path, params)
          #Encode and join the params
          encoded = URI.encode_www_form(params)
          [path, encoded].join("?")
        end

        def getRequestObject(config,metadata,input)
          
          #action,resourcePath,headerKey,queryKey,input
          
          #Separate the headers from the inputMap
          headers = Util.subMap(input,config.getHeaderParams())

          #Separate the query from the inputMap
          queryParams = Util.subMap(input,config.getQueryParams())
          
          #We need to resolve the host
          resolvedHost = metadata.getHost()

          resourcePath = config.getResoucePath().dup
          if (resourcePath.index("#env"))
            contenxt = ""
            
            if !metadata.getContext().nil? && !metadata.getContext().empty?
              contenxt = metadata.getContext()
            end
            
            resourcePath.sub!("#env", contenxt)
            resourcePath.sub!("//", "/") 
          end
          
          fullUrl = resolvedHost + resourcePath

          #Get the resourcePath containing values from input
          fullUrl = getFullResourcePath(config.getAction(),fullUrl,input)

          #Get the path parameters
          pathParams = getPathParams(config.getAction(),queryParams,input)
          #Get the body
          body = getBody(config.getAction(),input)

          #add url parameters  to path
          fullUrl = encode_path_params(fullUrl,pathParams)
          
          uri = URI(fullUrl)
          
          #Retuns the request object based on action
          case config.getAction().upcase
          when ACTION_LIST, ACTION_READ, ACTION_QUERY
            request = Net::HTTP::Get.new uri

          when ACTION_CREATE
            request = Net::HTTP::Post.new uri

          when ACTION_DELETE
            request = Net::HTTP::Delete.new uri

          when ACTION_UPDATE
            request = Net::HTTP::Put.new uri
          else
            raise APIException.new "Invalid action #{config.getAction()}"
          end

          

          #Add default headers
          request.add_field(KEY_ACCEPT,APPLICATION_JSON)
          request.add_field(KEY_CONTENT_TYPE,APPLICATION_JSON)
          request.add_field(KEY_USER_AGENT,RUBY_SDK+"/"+metadata.getVersion())

          #Add body

          unless body.nil?
            request.body = body.to_json
          end
          
          #Add headers to request
          headers.each do |key,value|
            request.add_field(key,value)
          end

          #Sign and get back the request
          request = Config.getAuthentication().signRequest(fullUrl,request,request.method,body,pathParams)

          return request


        end

        def preCheck()
          #check if execute can be done
          auth = Config.getAuthentication()

          unless (auth.nil? || auth.is_a?(Authentication))
            raise APIException.new "No or incorrect authentication has been configured"
          end

        end

        def removeForwardSlashFromTail(text)
          #
          #Removes the trailing / from url if any and returns the url

          if text.end_with? "/"
            return text[0...-1]
          end

          return text

        end

        def getFullResourcePath(action,resourcePath,inputMap)
          #
          #Forms the complete URL by combining baseURL and replaced path variables in resourcePath from inputMap


          #Remove the Trailing slash from the resource path
          resourcePath = removeForwardSlashFromTail(resourcePath)

          #Replace the path variables
          resourcePath = Util.getReplacedPath(resourcePath,inputMap)

          #This step is if id is in inputMap but was not specified in URL as /{id}
          #If the action is read,update or delete we add this id
          if inputMap.has_key?(KEY_ID)
            if [ACTION_READ,ACTION_UPDATE,ACTION_DELETE].include? action.upcase
              resourcePath += "/"+inputMap[KEY_ID].to_s
              inputMap.delete(KEY_ID) #Remove from input path otherwise this would get add in query params as well
            end
          end

          return resourcePath

        end

      end
    end
  end
end
