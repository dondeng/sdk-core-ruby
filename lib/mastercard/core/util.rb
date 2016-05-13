require 'uri'
require 'cgi'
require 'digest/sha1'
require 'base64'

module MasterCard
  module Core
    module Util
      extend self
      def validateURL(url)
        #
        # Validates that the given string is a valid URL
        return !URI.regexp.match(url).nil?

      end

      def normalizeParams(url,params)
        #
        # Combines the query parameters of url and extra params into a single queryString.
        # All the query string parameters are lexicographically sorted

        query = CGI.parse(URI.parse(url).query)
        query = params.merge(query)
        normalizedParams = Hash.new
        #Sort the parameters and
        query.sort.map do |key,value|
          if value.is_a?(Array)
            value = value.join(",")
          end

          normalizedParams[key] = value
        end

        return normalizedParams.map{ |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
      end


      def normalizeUrl(url)
        #Removes the query parameters from the URL
        url = URI.parse(url)
        return "#{url.scheme}://#{url.host}#{url.path}"

      end

      def subMap(inputMap,keyList)
        #
        #Returns a dict containing key, value from inputMap for keys in keyList
        #Matched keys are removed from inputMap
        ##
        subMap = Hash.new
        keyList.each do |key|
          if inputMap.key?(key)
            subMap[key] = inputMap[key]
            inputMap.delete(key)
          end
        end
        return subMap
      end


      def getReplacedPath(path,inputMap)
        ##
        #Replaces the {var} variables in path with value from inputMap
        #The replaced values are removed from inputPath

        #>>> getReplacedPath("http://localhost:8080/{var1}/car",{"var1" => 1})
        #    "http://localhost:8080/1/car"
        #
        #

        pathRegex = /{(.*?)}/
        matches = path.to_enum(:scan, pathRegex).map { Regexp.last_match }


        matches.each do |match|
          begin
            path["#{match[0]}"] = "%s"%inputMap.fetch(match[1])
            inputMap.delete(match[1])
          rescue
            raise KeyError, "Key \"#{match[1]}\" is not present in the input."
          end
        end

        return path
      end

      def base64Encode(text)
        #
        #Base 64 encodes the text
        return Base64.strict_encode64(text)
      end

      def sha1Base64Encode(text)
        #
        #Base 64 encodes the SHA1 digest of text
        return base64Encode(Digest::SHA1.digest text)
      end

      def uriRfc3986Encode(value)
        #
        #RFC 3986 encodes the value
        return CGI.escape(value)
      end
    end
  end
end
