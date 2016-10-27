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

require 'baseTest'
require 'user'
require 'mastercard/security/oauth'
require 'mastercard/core/model'


class UserTest < BaseTest
  include MasterCard::Security::OAuth
  include MasterCard::Core
  include MasterCard::Core::Model
  include MasterCard::Test


  def setup
    keyFile =  File.join(File.dirname(__FILE__), "resources", "mcapi_sandbox_key.p12")
    @auth = OAuth::OAuthAuthentication.new("L5BsiPgaF-O3qA36znUATgQXwJB6MRoMSdhjd7wt50c97279!50596e52466e3966546d434b7354584c4975693238513d3d",keyFile, "test", "password")
    Config.setAuthentication(@auth)
    Config.setDebug(true)
  end

  def self.test_order
    :alpha
  end

    
    
    
    
            

  def test_list_users
    #list_users
        

    mapObj = RequestMap.new

        

        

    ignoreAsserts = Array.new
        

    response = User.listByCriteria(mapObj)
    assertEqual(ignoreAsserts, "website", response[0].get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response[0].get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response[0].get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response[0].get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response[0].get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response[0].get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response[0].get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response[0].get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response[0].get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response[0].get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response[0].get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response[0].get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response[0].get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("list_users", response)
  end
    

  def test_list_users_query
    #list_users_query
        

    mapObj = RequestMap.new

    mapObj.set("max", "10")
        

        

    ignoreAsserts = Array.new
        

    response = User.listByCriteria(mapObj)
    assertEqual(ignoreAsserts, "website", response[0].get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response[0].get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response[0].get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response[0].get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response[0].get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response[0].get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response[0].get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response[0].get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response[0].get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response[0].get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response[0].get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response[0].get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response[0].get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("list_users_query", response)
  end
    
    
    
    
    
    
    
            
  def test_create_user
    #create_user
        

    mapObj = RequestMap.new

    mapObj.set("website", "hildegard.org")
    mapObj.set("address.city", "New York")
    mapObj.set("address.postalCode", "10577")
    mapObj.set("address.state", "NY")
    mapObj.set("address.line1", "2000 Purchase Street")
    mapObj.set("phone", "1-770-736-8031")
    mapObj.set("name", "Joe Bloggs")
    mapObj.set("email", "name@example.com")
    mapObj.set("username", "jbloggs")
        

        

    ignoreAsserts = Array.new
        

    response = User.create(mapObj)
    assertEqual(ignoreAsserts, "website", response.get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response.get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response.get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response.get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response.get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response.get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response.get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response.get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response.get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response.get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response.get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response.get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("create_user", response)
  end
    
    
    
    
    
    
    
    
    
    
    
    
    
            

  def test_get_user
    #get_user
        

    mapObj = RequestMap.new

        

    mapObj.set("id", BaseTest.resolveResponseValue("create_user.id"))
        
    id = mapObj.get("id") ? mapObj.get("id") : ""

    ignoreAsserts = Array.new
    ignoreAsserts.push("address.city");
        

    response = User.read(id, mapObj)
    assertEqual(ignoreAsserts, "website", response.get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response.get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response.get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response.get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response.get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response.get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response.get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response.get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response.get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response.get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response.get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response.get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("get_user", response)
  end

    

  def test_get_user_query
    #get_user_query
        

    mapObj = RequestMap.new

    mapObj.set("min", "1")
    mapObj.set("max", "10")
        

    mapObj.set("id", BaseTest.resolveResponseValue("create_user.id"))
        
    id = mapObj.get("id") ? mapObj.get("id") : ""

    ignoreAsserts = Array.new
        

    response = User.read(id, mapObj)
    assertEqual(ignoreAsserts, "website", response.get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response.get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response.get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response.get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response.get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response.get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response.get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response.get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response.get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response.get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response.get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response.get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("get_user_query", response)
  end

    
    
    
    
    
    
            

  def test_update_user
    #update_user
        

    mapObj = RequestMap.new

    mapObj.set("name", "Joe Bloggs")
    mapObj.set("username", "jbloggs")
    mapObj.set("email", "name@example.com")
    mapObj.set("phone", "1-770-736-8031")
    mapObj.set("website", "hildegard.org")
    mapObj.set("address.line1", "2000 Purchase Street")
    mapObj.set("address.city", "New York")
    mapObj.set("address.state", "NY")
    mapObj.set("address.postalCode", "10577")
        

    mapObj.set("id", BaseTest.resolveResponseValue("create_user.id"))
        

    ignoreAsserts = Array.new
        

    request = User.new(mapObj)
    response = request.update()
    assertEqual(ignoreAsserts, "website", response.get("website").to_s.downcase, "hildegard.org".downcase)
    assertEqual(ignoreAsserts, "address.instructions.doorman", response.get("address.instructions.doorman").to_s.downcase, "true".downcase)
    assertEqual(ignoreAsserts, "address.instructions.text", response.get("address.instructions.text").to_s.downcase, "some delivery instructions text".downcase)
    assertEqual(ignoreAsserts, "address.city", response.get("address.city").to_s.downcase, "New York".downcase)
    assertEqual(ignoreAsserts, "address.postalCode", response.get("address.postalCode").to_s.downcase, "10577".downcase)
    assertEqual(ignoreAsserts, "address.id", response.get("address.id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "address.state", response.get("address.state").to_s.downcase, "NY".downcase)
    assertEqual(ignoreAsserts, "address.line1", response.get("address.line1").to_s.downcase, "2000 Purchase Street".downcase)
    assertEqual(ignoreAsserts, "phone", response.get("phone").to_s.downcase, "1-770-736-8031".downcase)
    assertEqual(ignoreAsserts, "name", response.get("name").to_s.downcase, "Joe Bloggs".downcase)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "email", response.get("email").to_s.downcase, "name@example.com".downcase)
    assertEqual(ignoreAsserts, "username", response.get("username").to_s.downcase, "jbloggs".downcase)
        

    BaseTest.putResponse("update_user", response)
  end

    
    
    
    
    
    
    
    
    
    
    
            
  def test_delete_user
    #delete_user
        

    mapObj = RequestMap.new

        

    mapObj.set("id", BaseTest.resolveResponseValue("create_user.id"))
        
    id = mapObj.get("id") ? mapObj.get("id") : "ssss"

    ignoreAsserts = Array.new
        

    response = User.deleteById(id, mapObj)
        

    BaseTest.putResponse("delete_user", response)
  end
    

    
    
    
    

end

