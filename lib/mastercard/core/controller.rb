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
        JSON           = "JSON"


        def initialize
          #Set the parameters
          @baseURL = Config.getAPIBaseURL()

          @baseURL = removeForwardSlashFromTail(@baseURL)

          #Verify if the URL is correct
          unless Util.validateURL(@baseURL)
            raise APIException.new "URL: '" + @baseURL + "' is not a valid url"
          end

        end

        def execute(action,resourcePath,headerKey,input)

          #Check preconditions for execute
          preCheck()

          #Separate the headers from the inputMap
          headers = Util.subMap(input,headerKey)

          #Get the resourcePath containing values from input
          resourcePath = getFullResourcePath(action,resourcePath,input)

          #Get the path parameters
          pathParams = getPathParams(action,input)
          #Get the body
          body = getBody(action,input)

          #Get the request Object
          request = getRequestObject(resourcePath,action,pathParams,body)

          #Add headers to request
          headers.each do |key,value|
            request.add_field(key,value)
          end

          fullUrl = @baseURL+resourcePath
          #Sign and get back the request
          request = Config.getAuthentication().signRequest(fullUrl,request,request.method,body,pathParams)

          uri = URI.parse(@baseURL)
          #Get the http object
          http = getHTTPObject(uri)

          begin
            response = http.request(request)
            return handleResponse(response,response.body)
          rescue Errno::ECONNREFUSED
            raise APIException.new ("Connection to server could not be established.")
          end


        end


        private


        def handleResponse(response,content)
          #Handles the exception and response
          status = response.code.to_i

          if 200 <= status && status <= 299
            return content
          elsif 300 <= status && status <= 399
            raise InvalidRequestException.new("Unexpected response code returned from the API causing redirect",status,content)
          elsif status == 400
            raise InvalidRequestException.new("Bad request",status,content)
          elsif status == 401
            raise APIException.new("You are not authorized to make this request",status,content)
          elsif status == 403
            raise APIException.new("You are not authorized to make this request",status,content)
          elsif status == 404
            raise ObjectNotFoundException.new("Object not found",status,content)
          elsif status == 405
            raise APIException.new("Operation not allowed",status,content)
          else
            raise SystemException.new("Internal Server Error",status,content)
          end

        end

        def getBody(action,input)
          #Returns the body hash depending on action
          body = nil
          case action.upcase
          when ACTION_CREATE, ACTION_DELETE
            unless input.nil?
              body = input
            end
          end
          return body
        end

        def getPathParams(action,input)
          #Returns the path params based on action
          pathParams = {KEY_FORMAT => JSON}
          case action.upcase
          when ACTION_LIST, ACTION_READ, ACTION_QUERY, ACTION_DELETE
            unless input.nil?
              pathParams = pathParams.merge(input)
            end
          end
          return pathParams
        end

        def getHTTPObject(uri)
          #Returns the HTTP Object
          http = Net::HTTP.new(uri.host,uri.port)

          if Config.isDebug()
            http.set_debug_output($stdout)
          end

          unless Config.isLocal()
            http.use_ssl = true
          end

          return http

        end

        def encode_path_params(path, params)
          #Encode and join the params
          encoded = URI.encode_www_form(params)
          [path, encoded].join("?")
        end

        def getRequestObject(path,action,pathParams,body)
          #Retuns the request object based on action
          case action.upcase
          when ACTION_LIST, ACTION_READ, ACTION_QUERY
            verb = Net::HTTP::Get

          when ACTION_CREATE
            verb = Net::HTTP::Post

          when ACTION_DELETE
            verb = Net::HTTP::Delete

          when ACTION_UPDATE
            verb = Net::HTTP::Put
          else
            raise APIException.new "Invalid action #{action}"
          end

          #add url parameters  to path
          path = encode_path_params(path,pathParams)

          req = verb.new(path)

          #Add default headers
          req.add_field(KEY_ACCEPT,APPLICATION_JSON)
          req.add_field(KEY_CONTENT_TYPE,APPLICATION_JSON)
          req.add_field(KEY_USER_AGENT,RUBY_SDK+"/"+Constants::VERSION)

          #Add body

          unless body.nil?
            req.body = body.to_json
          end

          return req


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
