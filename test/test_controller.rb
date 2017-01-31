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
require 'resourceconfig'
require "mastercard/core/constants"
require "mastercard/core/controller"
require "mastercard/core/model"
require "mastercard/security/oauth"

class APIControllerTest < Minitest::Test
  include MasterCard::Core
  include MasterCard::Core::Controller
  include MasterCard::Core::Environment
  include MasterCard::Security
  include MasterCard::Core::Exceptions
  include MasterCard::Core::Model


  def setup

    keyFile =  File.join(File.dirname(__FILE__), "resources", "mcapi_sandbox_key.p12")
    @auth = OAuth::OAuthAuthentication.new("L5BsiPgaF-O3qA36znUATgQXwJB6MRoMSdhjd7wt50c97279!50596e52466e3966546d434b7354584c4975693238513d3d",keyFile, "test", "password")
    Config.setAuthentication(@auth)
    @controller = APIController.new

  end

  def test_initialization
    assert_kind_of APIController, @controller
  end

  def test_execute_wrongNoAuth

    Config.setAuthentication("skdhsdj")
    
    config = OperationConfig.new("/somePath", "query", [], [])
    metadata = OperationMetadata.new("0.0.1", nil)

    assert_raises APIException do
      @controller.execute(config, metadata, {})
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

  def test_getPathParams

    inputMap = {
        'three' => 3,
        'four'=> 4,
        'five'=> 5
    }

    queryMap = {

      "a" => 1,
      "b" => "2"
    }

    #Action create
    pathMap = @controller.send(:getPathParams,APIController::ACTION_CREATE, queryMap, inputMap)

    assert_equal({'a'=>1,'b'=>"2",'Format'=>'JSON'},pathMap)

    #action list
    pathMap = @controller.send(:getPathParams,APIController::ACTION_LIST, queryMap, inputMap)
    assert_equal({'a'=>1,'b'=>"2",'Format'=>'JSON','three'=>3,'four'=>4,'five'=>5},pathMap)



  end


  def test_config
    Config.setSandbox(true)
    assert_equal("sandbox", Config.getEnvironment())

    Config.setSandbox(false)
    assert_equal("production", Config.getEnvironment())

    Config.setEnvironment("stage")
    assert_equal("stage", Config.getEnvironment())

    Config.setEnvironment("production_itf")
    assert_equal("production_itf", Config.getEnvironment())

    Config.setEnvironment("")
    assert_equal("production_itf", Config.getEnvironment())

    Config.setEnvironment(nil)
    assert_equal("production_itf", Config.getEnvironment())

    Config.setSandbox(true)

  end


  def test_ResourceConfig
    resourceConfig = ResourceConfig.instance
    Config.registerResourceConfig(resourceConfig)
    resourceCongi2 = ResourceConfig.instance

    assert_equal(1, Config.sizeResourceConfig())

    Config.setEnvironment(Environment::SANDBOX)
    assert_equal("https://sandbox.api.mastercard.com",resourceConfig.getHost())
    assert_equal(resourceCongi2.getHost,resourceConfig.getHost())

    Config.setEnvironment(Environment::PRODUCTION)
    assert_equal("https://api.mastercard.com",resourceConfig.getHost())
    assert_equal(resourceCongi2.getHost,resourceConfig.getHost())

    Config.setEnvironment(Environment::STAGE)
    assert_equal("https://stage.api.mastercard.com",resourceConfig.getHost())
    assert_equal(resourceCongi2.getHost,resourceConfig.getHost())

    Config.setEnvironment(Environment::DEV)
    assert_equal("https://dev.api.mastercard.com",resourceConfig.getHost())
    assert_equal(resourceCongi2.getHost,resourceConfig.getHost())

  end

  
  
  def test_environment


    Config.setSandbox(true)
    assert_equal(1, Config.sizeResourceConfig())

    config = OperationConfig.new("/atms/v1/#env/locations", "query", [], [])

    Config.setEnvironment(Environment::SANDBOX)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://sandbox.api.mastercard.com/atms/v1/locations?Format=JSON", request.uri.to_s)

    Config.setEnvironment(Environment::STAGE)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://stage.api.mastercard.com/atms/v1/locations?Format=JSON", request.uri.to_s)

    Config.setEnvironment(Environment::PRODUCTION)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/locations?Format=JSON", request.uri.to_s)

    Config.setEnvironment(Environment::DEV)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://dev.api.mastercard.com/atms/v1/locations?Format=JSON", request.uri.to_s)

    Config.setEnvironment(Environment::PRODUCTION_MTF)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/mtf/locations?Format=JSON", request.uri.to_s)
    
    Config.setEnvironment(Environment::PRODUCTION_ITF)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/itf/locations?Format=JSON", request.uri.to_s)
    
    Config.setEnvironment("PEAT")
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/itf/locations?Format=JSON", request.uri.to_s)
    
    Config.setEnvironment("")
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/itf/locations?Format=JSON", request.uri.to_s)
    
    Config.setEnvironment(nil)
    metadata = OperationMetadata.new("0.0.1", ResourceConfig.instance.getHost(), ResourceConfig.instance.getContext())
    request = @controller.send(:getRequestObject,config,metadata,{})
    assert_equal("https://api.mastercard.com/atms/v1/itf/locations?Format=JSON", request.uri.to_s)
    
  end

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
