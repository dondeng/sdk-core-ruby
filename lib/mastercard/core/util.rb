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
        if url =~ URI::regexp
          return true
        else
          return false
        end
      end

      def normalizeParams(url,params)
        #
        # Combines the query parameters of url and extra params into a single queryString.
        # All the query string parameters are lexicographically sorted
        query = URI.parse(url).query

        unless query.nil?
          query = CGI.parse(URI.parse(url).query)
        end

        unless query.nil?
          query = params.merge(query)
        else
          query = params
        end

        normalizedParams = Hash.new
        #Sort the parameters and
        query.sort.map do |key,value|
          if value.is_a?(Array)
            value = value.join(",")
          end

          normalizedParams[key] = value
        end
        normalizedParams = normalizedParams.map{ |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
        return normalizedParams.gsub("+","%20")
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
