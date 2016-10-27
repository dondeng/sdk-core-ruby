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
require 'post'
require 'mastercard/security/oauth'
require 'mastercard/core/model'


class PostTest < BaseTest
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

    
    
    
    
            

  def test_list_posts_query_1
    #list_posts_query_1
        

    mapObj = RequestMap.new

        

        

    ignoreAsserts = Array.new
        

    response = Post.listByCriteria(mapObj)
    assertEqual(ignoreAsserts, "id", response[0].get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response[0].get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response[0].get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response[0].get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("list_posts_query_1", response)
  end
    

  def test_list_posts_query_2
    #list_posts_query_2
        

    mapObj = RequestMap.new

    mapObj.set("max", "10")
        

        

    ignoreAsserts = Array.new
        

    response = Post.listByCriteria(mapObj)
    assertEqual(ignoreAsserts, "id", response[0].get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response[0].get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response[0].get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response[0].get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("list_posts_query_2", response)
  end
    
    
    
    
    
    
    
            
  def test_create_post_test_only
    #create_post_test_only

    mapObj = RequestMap.new

    mapObj.set("title", "Title of Post")
    mapObj.set("body", "Some text as a body")
        

        

    ignoreAsserts = Array.new
        

    response = Post.create(mapObj)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response.get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response.get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response.get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("create_post_test_only", response)
  end
    
    
    
    
    
    
    
    
    
    
    
    
    
            

  def test_get_post_query_1
    #get_post_query_1
        

    mapObj = RequestMap.new

        

        
    id = mapObj.get("id") ? mapObj.get("id") : "1"

    ignoreAsserts = Array.new
        

    response = Post.read(id, mapObj)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response.get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response.get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response.get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("get_post_query_1", response)
  end

    

  def test_get_post_query_2
    #get_post_query_2
        

    mapObj = RequestMap.new

    mapObj.set("min", "1")
    mapObj.set("max", "10")
        

        
    id = mapObj.get("id") ? mapObj.get("id") : "1"

    ignoreAsserts = Array.new
        

    response = Post.read(id, mapObj)
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response.get("title").to_s.downcase, "My Title".downcase)
    assertEqual(ignoreAsserts, "body", response.get("body").to_s.downcase, "some body text".downcase)
    assertEqual(ignoreAsserts, "userId", response.get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("get_post_query_2", response)
  end

    
    
    
    
    
    
            

  def test_update_post
    #update_post
        

    mapObj = RequestMap.new

    mapObj.set("id", "1111")
    mapObj.set("title", "updated title")
    mapObj.set("body", "updated body")
        

        

    ignoreAsserts = Array.new
        

    request = Post.new(mapObj)
    response = request.update()
    assertEqual(ignoreAsserts, "id", response.get("id").to_s.downcase, "1".downcase)
    assertEqual(ignoreAsserts, "title", response.get("title").to_s.downcase, "updated title".downcase)
    assertEqual(ignoreAsserts, "body", response.get("body").to_s.downcase, "updated body".downcase)
    assertEqual(ignoreAsserts, "userId", response.get("userId").to_s.downcase, "1".downcase)
        

    BaseTest.putResponse("update_post", response)
  end

    
    
    
    
    
    
    
    
    
    
    
            
  def test_delete_post
    #delete_post
        

    mapObj = RequestMap.new

        

        
    id = mapObj.get("id") ? mapObj.get("id") : "1"

    ignoreAsserts = Array.new
        

    response = Post.deleteById(id, mapObj)
        

    BaseTest.putResponse("delete_post", response)
  end
    

    
    
    
    

end

