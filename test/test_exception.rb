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
require 'test_helper'
require 'mastercard/core/exceptions'

class ExceptionTest < Minitest::Test
  include MasterCard::Core::Exceptions

  def test_api_exception_without_errorcode

    exceptionObj =  APIException.new "naman", 200
    assert_equal(200,exceptionObj.getStatus)
    assert_equal("naman",exceptionObj.getMessage)
    assert_equal(nil,exceptionObj.getErrorCode)
    assert_equal("%s"%exceptionObj,'MasterCard::Core::Exceptions::APIException: "naman" (status: 200)')
  end

  def test_api_exception_with_errorcode

    exceptionObj =  APIException.new "naman", 400, {"Errors" => {"Error"=>{"ReasonCode"=>2098,"Message"=>"This is an Error"}}}
    assert_equal(400,exceptionObj.getStatus)
    assert_equal("This is an Error",exceptionObj.getMessage)
    assert_equal(2098,exceptionObj.getErrorCode)
    assert_equal("%s"%exceptionObj,'MasterCard::Core::Exceptions::APIException: "This is an Error" (status: 400, error code: 2098)')
  end


  def test_api_exception_with_array

    exceptionObj =  APIException.new "naman", 400, [{"ReasonCode"=>2098,"Message"=>"This is an Error"}]
    assert_equal(400,exceptionObj.getStatus)
    assert_equal("This is an Error",exceptionObj.getMessage)
    assert_equal(2098,exceptionObj.getErrorCode)
    assert_equal("%s"%exceptionObj,'MasterCard::Core::Exceptions::APIException: "This is an Error" (status: 400, error code: 2098)')
  end

  def test_api_connection_exception

      exceptionObj =  APIConnectionException.new "Some error"
      assert_equal(500,exceptionObj.getStatus)

  end

  def test_authentication_exception

      exceptionObj =  AuthenticationException.new "Some error"
      assert_equal(401,exceptionObj.getStatus)

  end

  def test_not_allowed_exception

      exceptionObj =  NotAllowedException.new "Some error"
      assert_equal(403,exceptionObj.getStatus)

  end

  def test_system_exception

      exceptionObj =  SystemException.new "Some error"
      assert_equal(500,exceptionObj.getStatus)

  end

  def test_invalid_request_exception

    exceptionObj =  InvalidRequestException.new("Some error",400, {"Errors" => {"Error"=>{"ReasonCode"=>2213,"Message"=>"This is an error","FieldErrors"=>[{"field"=>"Password", "message" => "Password should be of atleast 8 characters", "code" => 1024},{"field"=>"Username", "message" => "Username should be of atleast 8 characters", "code" => 1025}]}}})
    assert_equal(400,exceptionObj.getStatus)
    assert(exceptionObj.hasFieldErrors)
    assert_equal(2,exceptionObj.getFieldErrors().length)

    message = 'MasterCard::Core::Exceptions::InvalidRequestException: "This is an error" (status: 400, error code: 2213)'
    message << "\n Field Error: Password \"Password should be of atleast 8 characters\" (1024)"
    message << "\n Field Error: Username \"Username should be of atleast 8 characters\" (1025)"

    assert_equal(message,"%s"%exceptionObj)

  end

  def test_field_error

      errorObj =  FieldError.new({"field"=>"Password", "message" => "Password should be of atleast 8 characters", "code" => 1024})
      assert_equal("Password",errorObj.getFieldName)
      assert_equal("Password should be of atleast 8 characters",errorObj.getErrorMessage)
      assert_equal(1024,errorObj.getErrorCode)
      assert_equal('Field Error: Password "Password should be of atleast 8 characters" (1024)',"%s"%errorObj)

  end


end
