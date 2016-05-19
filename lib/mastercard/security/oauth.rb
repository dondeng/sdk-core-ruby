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
require "mastercard/security/authentication"
require "mastercard/security/util"
require "mastercard/core/util"
require "openssl"

module MasterCard
  module Security
    module OAuth
      include MasterCard::Security

      class OAuthAuthentication < Authentication
        include MasterCard::Core::Util

        def initialize(clientId,privateKey,key_alias,password)

          @clientId   = clientId
          @privateKey = privateKey
          @alias      = key_alias
          @password   = password

        end

        def getClientId
          return @clientId
        end

        def getPrivateKey
          return @privateKey
        end

        def getOAuthBaseParameters(url, method, body)
          oAuthParameters = OAuthParameters.new
          oAuthParameters.setOAuthConsumerKey(@clientId)
          oAuthParameters.setOAuthNonce(Util.getNonce())
          oAuthParameters.setOAuthTimestamp(Util.getTimestamp())
          oAuthParameters.setOAuthSignatureMethod("RSA-SHA1")
          oAuthParameters.setOAuthVersion("1.0")

          if body.nil?
            body = ""
          end

          begin
            body = body.to_json
          rescue
            #Do nothing and hope for the best
          end

          encodedHash = sha1Base64Encode(body)
          oAuthParameters.setOAuthBodyHash(encodedHash)

          return oAuthParameters
        end

        def getBaseString(url,method,params,oAuthParams)
          #Merge the query string parameters
          unless params.nil?
            mergeParams = oAuthParams.merge(params)
          else
            mergeParams = oAuthParams
          end

          normalParams = normalizeParams(url,mergeParams)
          normalUrl    = normalizeUrl(url)
          method       = method.upcase

          return "#{uriRfc3986Encode(method)}&#{uriRfc3986Encode(normalUrl)}&#{uriRfc3986Encode(normalParams)}"
        end


        def signRequest(url,request,method,data,params)

          oauth_key = getOAuthKey(url,method,data,params)
          request.add_field(OAuthParameters::AUTHORIZATION,oauth_key)
          return request

        end

        def getOAuthKey(url,method,body,params)

          #Get all the base parameters such as nonce and timestamp
          oAuthBaseParameters = getOAuthBaseParameters(url,method,body)
          #Get the base string
          baseString = getBaseString(url, method, params,oAuthBaseParameters.getBaseParametersHash())

          #Sign the base string using the private key
          signature = signMessage(baseString)

          #Set the signature in the Base parameters
          oAuthBaseParameters.setOAuthSignature(signature)

          #Get the updated base parameteres dict
          oAuthBaseParametersHash = oAuthBaseParameters.getBaseParametersHash()

          paramStr = oAuthBaseParametersHash.map { |k,v|  "#{uriRfc3986Encode(k)}=\"#{uriRfc3986Encode(v.to_s)}\""}.join(",")

          #Generate the header value for OAuth Header
          return "#{OAuthParameters::OAUTH_KEY} #{paramStr}"


        end


        def signMessage(message)
          #
          #Signs the message using the private key with sha1 as digest
          privateKeyFile = File.read(@privateKey)

          p12 = OpenSSL::PKCS12.new(privateKeyFile, @password)
          sign = p12.key.sign OpenSSL::Digest::SHA1.new, message

          return base64Encode(sign)

        end

      end

      class OAuthParameters

        OAUTH_BODY_HASH_KEY = "oauth_body_hash"
        OAUTH_CALLBACK_KEY = "oauth_callback"
        OAUTH_CONSUMER_KEY = "oauth_consumer_key"
        OAUTH_CONSUMER_SECRET = "oauth_consumer_secret"
        OAUTH_NONCE_KEY = "oauth_nonce"
        OAUTH_KEY = "OAuth"
        AUTHORIZATION = "Authorization"
        OAUTH_SIGNATURE_KEY = "oauth_signature"
        OAUTH_SIGNATURE_METHOD_KEY = "oauth_signature_method"
        OAUTH_TIMESTAMP_KEY = "oauth_timestamp"
        OAUTH_TOKEN_KEY = "oauth_token"
        OAUTH_TOKEN_SECRET_KEY = "oauth_token_secret"
        OAUTH_VERIFIER_KEY = "oauth_verifier"
        REALM_KEY = "realm"
        XOAUTH_REQUESTOR_ID_KEY = "xoauth_requestor_id"
        OAUTH_VERSION = "oauth_version"


        def initialize
          @baseParameters = Hash.new
        end

        def put(key,value)
          @baseParameters[key] = value
        end

        def setOAuthConsumerKey(consumerKey)
          put(OAuthParameters::OAUTH_CONSUMER_KEY, consumerKey)
        end

        def setOAuthNonce(oAuthNonce)
          put(OAuthParameters::OAUTH_NONCE_KEY, oAuthNonce)
        end

        def setOAuthTimestamp(timestamp)
          put(OAuthParameters::OAUTH_TIMESTAMP_KEY, timestamp)
        end

        def setOAuthSignatureMethod(signatureMethod)
          put(OAuthParameters::OAUTH_SIGNATURE_METHOD_KEY, signatureMethod)
        end

        def setOAuthSignature(signature)
          put(OAuthParameters::OAUTH_SIGNATURE_KEY, signature)
        end

        def setOAuthBodyHash(bodyHash)
          put(OAuthParameters::OAUTH_BODY_HASH_KEY, bodyHash)
        end

        def setOAuthVersion(version)
          put(OAuthParameters::OAUTH_VERSION, version)
        end

        def getBaseParametersHash
          return @baseParameters
        end


      end



    end
  end
end
