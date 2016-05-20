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
require 'mastercard/core/model'

class ConfigTest < Minitest::Test
  include MasterCard::Core::Model

  def test_initialization
    baseMapObj = BaseMap.new
    assert_equal({},baseMapObj.getObject())
  end


  def test_simple_set

    baseMapObj = BaseMap.new
    baseMapObj.set("user",122132)

    assert_equal({'user'=>122132},baseMapObj.getObject())

    baseMapObj.set("name","naman")
    assert_equal({'user'=>122132,'name'=>'naman'},baseMapObj.getObject())

    #Override the value
    baseMapObj.set("name","atul")
    assert_equal({'user'=>122132,'name'=>'atul'},baseMapObj.getObject())

  end

  def test_nested_set

    baseMapObj = BaseMap.new

    baseMapObj.set("user.name.first","Naman")
    assert_equal({'user'=>{'name'=>{'first'=>'Naman'}}},baseMapObj.getObject())

    baseMapObj.set("user.name.last.middle","Kumar")
    assert_equal({'user'=>{'name'=>{'first'=>'Naman','last'=>{'middle'=>'Kumar'}}}},baseMapObj.getObject())

    baseMapObj.set("user.name.last.last","Aggarwal")
    assert_equal({'user'=>{'name'=>{'first'=>'Naman','last'=>{'middle'=>'Kumar','last'=>'Aggarwal'}}}},baseMapObj.getObject())
  end


  def test_NestedSetWithList

    baseMapObj = BaseMap.new

    baseMapObj.set("user.name[0]","Naman")
    assert_equal({'user'=>{'name'=>['Naman']}},baseMapObj.getObject())

    baseMapObj.set("user.name[1]","Kumar")
    assert_equal({'user'=>{'name'=>['Naman','Kumar']}},baseMapObj.getObject())

    baseMapObj.set("user.name[2]","Aggarwal")
    assert_equal({'user'=>{'name'=>['Naman','Kumar','Aggarwal']}},baseMapObj.getObject())

    baseMapObj.set("user.name[3].class.id",1233)
    assert_equal({'user'=>{'name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]}},baseMapObj.getObject())
  end


  def test_SetInvalidAction

    baseMapObj = BaseMap.new

    baseMapObj.set("user.name[0]","Naman")
    baseMapObj.set("user.name[1]","Kumar")
    baseMapObj.set("user.name[2]","Aggarwal")

    assert_raises KeyError do
      baseMapObj.set("user.name.class.id",1233)
    end

    assert_equal({'user'=>{'name'=>['Naman','Kumar','Aggarwal']}},baseMapObj.getObject())
  end

  def test_get

    baseMapObj = BaseMap.new

    baseMapObj.set("user.name[0]","Naman")
    baseMapObj.set("user.name[1]","Kumar")
    baseMapObj.set("user.name[2]","Aggarwal")
    baseMapObj.set("user.name[3].class.id",1233)
    baseMapObj.set("employee[0].name","atul")
    baseMapObj.set("employee[1].name","sumit")

    assert_equal({'name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]},baseMapObj.get("user"))
    assert_equal(['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}],baseMapObj.get("user.name"))
    assert_equal({'class'=>{'id'=>1233}},baseMapObj.get("user.name[3]"))
    assert_equal({'id'=>1233},baseMapObj.get("user.name[3].class"))
    assert_equal(1233,baseMapObj.get("user.name[3].class.id"))

    assert_equal(nil,baseMapObj.get("user.name[3].class.id.value"))

    assert_equal(nil,baseMapObj.get("user.name[4].class.id.value"))

    assert_equal([{'name'=>'atul'},{'name'=>'sumit'}],baseMapObj.get("employee"))

    assert_equal(nil,baseMapObj.get("employee[3]"))

    assert_equal(nil,baseMapObj.get("user.name[4].class"))

    #check object is still the same
    assert_equal({"user"=>{'name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]},"employee"=>[{'name'=>'atul'},{'name'=>'sumit'}]},baseMapObj.getObject())

  end

  def testSetAll

    baseMapObj = BaseMap.new

    baseMapObj.setAll({'user.name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]})
    self.assertEqual({"user"=>{'name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]}},baseMapObj.getObject())

    baseMapObj.setAll({'employee.name'=>'atul'})
    self.assertDictEqual({"user"=>{'name'=>['Naman','Kumar','Aggarwal',{'class'=>{'id'=>1233}}]},"employee"=>{"name"=>"atul"}},baseMapObj.getObject())


    baseMapObj = BaseMap()

    baseMapObj.setAll([{"user.name"=>"Naman","user.lastname"=>"Aggarwal"}])
    self.assertEqual({"list"=>[{"user"=>{"name"=>"Naman","lastname"=>"Aggarwal"}}]},baseMapObj.getObject())
  end


end
