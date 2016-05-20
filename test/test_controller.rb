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
require "mastercard/core/controller"
require "mastercard/security/oauth"

class APIControllerTest < Minitest::Test
  include MasterCard::Core
  include MasterCard::Core::Controller
  include MasterCard::Security
  include MasterCard::Core::Exceptions

  def setup

    keyFile =  File.join(File.dirname(__FILE__), "resources", "prod_key.p12")
    @auth = OAuth::OAuthAuthentication.new("gVaoFbo86jmTfOB4NUyGKaAchVEU8ZVPalHQRLTxeaf750b6!414b543630362f426b4f6636415a5973656c33735661383d",keyFile, "alias", "password")
    Config.setAuthentication(@auth)
    @controller = APIController.new

  end


  def test_initialization
    assert_kind_of APIController, @controller
  end

  def test_execute_wrongNoAuth

    Config.setAuthentication("skdhsdj")

    assert_raises APIException do
      @controller.execute("some","some","seom","some")
    end

  end

  def test_removeForwareSlashFromTail

    #Url with /
    assert_equal("http://localhost:8080",@controller.send(:removeForwardSlashFromTail,"http://localhost:8080/"))

    #Url with parameters and /
    assert_equal("http://localhost:8080/?nam=1&an=1",@controller.send(:removeForwardSlashFromTail,"http://localhost:8080/?nam=1&an=1/"))

    #Url without /
    assert_equal("http://localhost:8080",@controller.send(:removeForwardSlashFromTail,"http://localhost:8080"))


  end
=begin
  def test_execute_local

    stub_local = stub_request(:get, "http://localhost:8080/user/1?Format=JSON&b=naman%20aggarwal%20%2520&id=3").
      to_return(:status => 200, :body => "naman", :headers => {})

    input = {


        "a"=>1,
        "b"=>"naman aggarwal %20",
        "id"=>3
    }

    header = []

    action = "list"
    resourcePath = "/user/{a}"

    Config.setLocal(true)

    cont = APIController.new
    response = cont.execute(action,resourcePath,header,input)

    assert_equal("naman",response)

    Config.setLocal(false)
    remove_request_stub(stub_local)
  end

  def test_execute_local

    input = {


        "a"=>1,
        "b"=>"naman aggarwal %20",
        "id"=>3
    }

    header = []

    action = "list"
    resourcePath = "/user/{a}"

    Config.setLocal(true)

    cont = APIController.new


    response = cont.execute(action,resourcePath,header,input)


    assert_equal("naman",response)

    Config.setLocal(false)
  end


  def test_execute_local_301

    stub_local= stub_request(:get, "http://localhost:8080/user/1?Format=JSON&b=naman%20aggarwal%20%2520&id=3").
      to_return(:status => 301, :body => "", :headers => {})

    input = {
        "a"=>1,
        "b"=>"naman aggarwal %20",
        "id"=>3
    }
    header = []

    action = "list"
    resourcePath = "/user/{a}"

    Config.setLocal(true)

    exc = assert_raises InvalidRequestException do
      cont = APIController.new
      cont.execute(action,resourcePath,header,input)
    end

    Config.setLocal(false)
    remove_request_stub(stub_local)
  end

  def test_execute_sandbox_not_found

    input = {
        "a"=>1,
        "b"=>"naman aggarwal %20",
        "id"=>3
    }
    header = []

    action = "list"
    resourcePath = "/user/{a}"


    assert_raises ObjectNotFoundException do
      @controller.execute(action,resourcePath,header,input)
    end

  end
=end

  def test_getFullResourcePath

    inputMap = {
        'api' => 'lostandstolen',
        'version' => 1,
        'three' => 3,
        'four'=> 4,
        'five'=> 5
    }

    url = @controller.send(:getFullResourcePath,APIController::ACTION_CREATE, "/fraud/{api}/v{version}/account-inquiry", inputMap)

    #Normal URL
    assert_equal("/fraud/lostandstolen/v1/account-inquiry",url)
    assert_equal(3,inputMap.length)

    inputMap = {
        'api' => 'lostandstolen',
        'version' => 1,
        'three' => 3,
        'four'=> 4,
        'five'=>5
    }

    #URL with trailing /
    url = @controller.send(:getFullResourcePath,APIController::ACTION_CREATE, "/fraud/{api}/v{version}/account-inquiry/", inputMap)
    assert_equal("/fraud/lostandstolen/v1/account-inquiry",url)
    assert_equal(3,inputMap.length)

    inputMap = {
        'api' => 'lostandstolen',
        'version' => 1,
        'three' => 3,
        'id'=>1
    }

    #URL with id and action delete
    url = @controller.send(:getFullResourcePath,APIController::ACTION_DELETE, "/fraud/{api}/v{version}/account-inquiry/{id}", inputMap)
    assert_equal("/fraud/lostandstolen/v1/account-inquiry/1",url)
    assert_equal(1,inputMap.length)


    inputMap = {
        'api' => 'lostandstolen',
        'version' => 1,
        'three' => 3,
        'id'=>1
    }

    #URL with id in inputMap but not in url
    url = @controller.send(:getFullResourcePath,APIController::ACTION_DELETE, "/fraud/{api}/v{version}/account-inquiry/", inputMap)
    assert_equal("/fraud/lostandstolen/v1/account-inquiry/1",url)
    assert_equal(1,inputMap.length)

    inputMap = {
        'api' => 'lostandstolen',
        'version' => 1,
        'three' => 3,
        'id'=>1
    }

    #URL with id in inputMap but not in url and method create
    url = @controller.send(:getFullResourcePath,APIController::ACTION_CREATE, "/fraud/{api}/v{version}/account-inquiry/", inputMap)
    assert_equal("/fraud/lostandstolen/v1/account-inquiry",url)
    assert_equal(2,inputMap.length)

    #Now that the key api and version are not there in map
    #This should raise a key error
    assert_raises KeyError do
      url = @controller.send(:getFullResourcePath,APIController::ACTION_CREATE, "/fraud/{api}/v{version}/account-inquiry/", inputMap)

    end

  end


end
