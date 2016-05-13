require 'minitest/autorun'
require 'mastercard/core/util'

class UtilTest < Minitest::Test
  include MasterCard::Core::Util

  def test_validateURL

    #Normal url
    assert(validateURL("http://www.mastercard.com"))

    #Url ending with /
    assert(validateURL("http://www.mastercard.com/"))

    #Url with query Params
    assert(validateURL("http://www.developer.mastercard.com?q=some&e=other"))

    #localhost with port and query
    assert(validateURL("http://localhost:8080?q=some&e=other"))

    #localhost with port and query
    assert(!validateURL("sdfddffd"))

  end

  def test_normalizeParams

    url = "http://www.naman.com/abc?c=1&d=2&a=3"
    params = {
        "m"=>2,
        "b"=>3,
        "k"=>"5"
    }

    nurl = normalizeParams(url,params)

    assert_equal("a=3&b=3&c=1&d=2&k=5&m=2",nurl)

  end

  def test_normalizeUrl
    url = "http://www.naman.com/abc?c=1&d=2&a=3"
    url = normalizeUrl(url)
    assert_equal("http://www.naman.com/abc",url)
  end


  def test_subMap

    inputMap = {
        "one" => 1,
        "two" =>2,
        "three"=>"3",
        "four"=>4,
        "five"=>5
    }

    keyList = ['one','three','five']

    subMap = subMap(inputMap,keyList)

    assert_equal(3,subMap.length)
    assert_equal(1,subMap['one'])
    assert_equal("3",subMap['three'])
    assert_equal(5,subMap['five'])

    assert_equal(2,inputMap.length)
    assert_equal(2,inputMap['two'])
    assert_equal(4,inputMap['four'])
  end

  def test_getReplacedPath

    inputMap = {
        "one" => 1,
        "two" =>2,
        "three"=>"3",
        "four"=>4,
        "five"=>5
    }

    path = "http://localhost:8080/{one}/{two}/{three}/car"

    res = getReplacedPath(path,inputMap)

    assert_equal("http://localhost:8080/1/2/3/car",res)
    assert_equal(2,inputMap.length)

    #Since now map does not have Key one this should raise KeyError
    assert_raises KeyError do
      path = "http://localhost:8080/{one}/{two}/{three}/car"
      res = getReplacedPath(path,inputMap)
    end

  end


  def test_sha1Base64Encode

    body = '<?xml version="1.0" encoding="Windows-1252"?><ns2:TerminationInquiryRequest xmlns:ns2="http://mastercard.com/termination"><AcquirerId>1996</AcquirerId><TransactionReferenceNumber>1</TransactionReferenceNumber><Merchant><Name>TEST</Name><DoingBusinessAsName>TEST</DoingBusinessAsName><PhoneNumber>5555555555</PhoneNumber><NationalTaxId>1234567890</NationalTaxId><Address><Line1>5555 Test Lane</Line1><City>TEST</City><CountrySubdivision>XX</CountrySubdivision><PostalCode>12345</PostalCode><Country>USA</Country></Address><Principal><FirstName>John</FirstName><LastName>Smith</LastName><NationalId>1234567890</NationalId><PhoneNumber>5555555555</PhoneNumber><Address><Line1>5555 Test Lane</Line1><City>TEST</City><CountrySubdivision>XX</CountrySubdivision><PostalCode>12345</PostalCode><Country>USA</Country></Address><DriversLicense><Number>1234567890</Number><CountrySubdivision>XX</CountrySubdivision></DriversLicense></Principal></Merchant></ns2:TerminationInquiryRequest>'

    #string
    assert_equal("WhqqH+TU95VgZMItpdq78BWb4cE=",sha1Base64Encode(body))

    assert_equal("rJR8KaAuZGLaEJFaq6hr3XMpYIQ=",sha1Base64Encode("naman"))

    assert_equal("z8QBItnqBvnQ5fMkqkjVQXwncv4=",sha1Base64Encode("naman@3476@$%%^*%&^#mastercard"))

    assert_equal("2jmj7l5rSw0yVb/vlWAYkK/YBwk=",sha1Base64Encode(""))



  end

  def test_uriRfc3986Encode
    encode = uriRfc3986Encode("Formal=XML")
    assert_equal("Formal%3DXML",encode)

    encode = uriRfc3986Encode("WhqqH+TU95VgZMItpdq78BWb4cE=")
    assert_equal("WhqqH%2BTU95VgZMItpdq78BWb4cE%3D",encode)

    encode = uriRfc3986Encode("WhqqH+TU95VgZMItpdq78BWb4cE=&o")
    assert_equal("WhqqH%2BTU95VgZMItpdq78BWb4cE%3D%26o",encode)

  end


end
