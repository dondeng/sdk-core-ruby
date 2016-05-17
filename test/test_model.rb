require 'minitest/autorun'
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
