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
require 'multiplepathuserpost'
require 'mastercard/security/oauth'
require 'mastercard/core/model'


class MultiplePathUserPostTest < BaseTest
  include MasterCard::Security::OAuth
  include MasterCard::Core
  include MasterCard::Core::Model
  include MasterCard::Test


  def setup
    keyFile =  File.join(File.dirname(__FILE__), "resources", "mcapi_sandbox_key.p12")
    @auth = OAuth::OAuthAuthentication.new("L5BsiPgaF-O3qA36znUATgQXwJB6MRoMSdhjd7wt50c97279!50596e52466e3966546d434b7354584c4975693238513d3d",keyFile, "alias", "password")
    Config.setAuthentication(@auth)
    Config.setDebug(true)
  end

  def self.test_order
    :alpha
  end

    
    
    
    
            

  def test_get_user_posts_with_mutplie_path
    #get_user_posts_with_mutplie_path
        

    mapObj = RequestMap.new

    mapObj.set("user_id", "1")
    mapObj.set("post_id", "2")
        

        

    ignoreAsserts = Array.new
        

    response = MultiplePathUserPost.listByCriteria(mapObj)
    assertEqual(ignoreAsserts, "id", response[0].get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response[0].get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response[0].get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response[0].get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("get_user_posts_with_mutplie_path", response)
  end
    
    
    
    
    
    
    
    
            

  def test_update_user_posts_with_mutplie_path
    #update_user_posts_with_mutplie_path
        

    mapObj = RequestMap.new

    mapObj.set("user_id", "1")
    mapObj.set("post_id", "1")
    mapObj.set("testQuery", "testQuery")
    mapObj.set("name", "Joe Bloggs")
    mapObj.set("username", "jbloggs")
    mapObj.set("email", "name@example.com")
    mapObj.set("phone", "1-770-736-8031")
    mapObj.set("website", "hildegard.org")
    mapObj.set("address.line1", "2000 Purchase Street")
    mapObj.set("address.city", "New York")
    mapObj.set("address.state", "NY")
    mapObj.set("address.postalCode", "10577")
        

        

    ignoreAsserts = Array.new
        

    request = MultiplePathUserPost.new(mapObj)
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
        

    BaseTest.putResponse("update_user_posts_with_mutplie_path", response)
  end

    
    
    
    
    
    
    
    
    
    
    
            
  def test_delete_user_posts_with_mutplie_path
    #delete_user_posts_with_mutplie_path
        

    mapObj = RequestMap.new

    mapObj.set("user_id", "1")
    mapObj.set("post_id", "2")
        

        
    id = mapObj.get("id") ? mapObj.get("id") : ""

    ignoreAsserts = Array.new
        

    response = MultiplePathUserPost.deleteById(id, mapObj)
        

    BaseTest.putResponse("delete_user_posts_with_mutplie_path", response)
  end
    

    
    
    
    

end

