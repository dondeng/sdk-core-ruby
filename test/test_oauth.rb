require 'minitest/autorun'
require 'mastercard/security/oauth'


class OAuthTest < Minitest::Test
  include MasterCard::Security
  include MasterCard::Security::OAuth
  include MasterCard::Core::Util

  def createOAuthObject
    keyFile =  File.join(File.dirname(__FILE__), "resources", "MCOpenAPI.p12")
    @auth = OAuthAuthentication.new("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", keyFile, "mckp", "mcapi")
  end

  def test_auth_base_class
    auth = Authentication.new
    assert_raises NotImplementedError do
      auth.signRequest("http://www.naman.com","something")
    end

  end

  def test_oauth_signrequest
    auth = OAuthParameters.new

    auth.setOAuthConsumerKey("dshjsd")

    createOAuthObject()

    @auth.getOAuthKey("http://www.google.com","GET","[]",{})

    #print(auth.getBaseParametersHash)
  end

  def test_oauth_util_getTimeStamp

    timestamp = Util.getTimestamp()
    assert_equal(10,timestamp.to_s.length)
  end

  def test_getNonce

    nonce = Util.getNonce()
    assert_equal(16,nonce.length)

    nonce = Util.getNonce(10)
    assert_equal(10,nonce.length)
  end


  def test_getBaseString

    createOAuthObject()

    body = '<?xml version="1.0" encoding="Windows-1252"?><ns2:TerminationInquiryRequest xmlns:ns2="http://mastercard.com/termination"><AcquirerId>1996</AcquirerId><TransactionReferenceNumber>1</TransactionReferenceNumber><Merchant><Name>TEST</Name><DoingBusinessAsName>TEST</DoingBusinessAsName><PhoneNumber>5555555555</PhoneNumber><NationalTaxId>1234567890</NationalTaxId><Address><Line1>5555 Test Lane</Line1><City>TEST</City><CountrySubdivision>XX</CountrySubdivision><PostalCode>12345</PostalCode><Country>USA</Country></Address><Principal><FirstName>John</FirstName><LastName>Smith</LastName><NationalId>1234567890</NationalId><PhoneNumber>5555555555</PhoneNumber><Address><Line1>5555 Test Lane</Line1><City>TEST</City><CountrySubdivision>XX</CountrySubdivision><PostalCode>12345</PostalCode><Country>USA</Country></Address><DriversLicense><Number>1234567890</Number><CountrySubdivision>XX</CountrySubdivision></DriversLicense></Principal></Merchant></ns2:TerminationInquiryRequest>'
    method = "POST"
    url = "https://sandbox.api.mastercard.com/fraud/merchant/v1/termination-inquiry?Format=XML&PageOffset=0"
    params = {"PageLength"=>10}

    oAuthParameters = OAuthParameters.new
    oAuthParameters.setOAuthConsumerKey("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    oAuthParameters.setOAuthNonce("1111111111111111111")
    oAuthParameters.setOAuthTimestamp("1111111111")
    oAuthParameters.setOAuthSignatureMethod("RSA-SHA1")
    oAuthParameters.setOAuthVersion("1.0")
    encodedHash = sha1Base64Encode(body)
    oAuthParameters.setOAuthBodyHash(encodedHash)

    baseString = @auth.getBaseString(url, method,params, oAuthParameters.getBaseParametersHash())
    assert_equal('POST&https%3A%2F%2Fsandbox.api.mastercard.com%2Ffraud%2Fmerchant%2Fv1%2Ftermination-inquiry&Format%3DXML%26PageLength%3D10%26PageOffset%3D0%26oauth_body_hash%3DWhqqH%252BTU95VgZMItpdq78BWb4cE%253D%26oauth_consumer_key%3Dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%26oauth_nonce%3D1111111111111111111%26oauth_signature_method%3DRSA-SHA1%26oauth_timestamp%3D1111111111%26oauth_version%3D1.0',baseString)
  end

  def test_signMessage

    createOAuthObject()
    baseString = 'POST&https%3A%2F%2Fsandbox.api.mastercard.com%2Ffraud%2Fmerchant%2Fv1%2Ftermination-inquiry&Format%3DXML%26PageLength%3D10%26PageOffset%3D0%26oauth_body_hash%3DWhqqH%252BTU95VgZMItpdq78BWb4cE%253D%26oauth_consumer_key%3Dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%26oauth_nonce%3D1111111111111111111%26oauth_signature_method%3DRSA-SHA1%26oauth_timestamp%3D1111111111%26oauth_version%3D1.0'

    signature = @auth.signMessage(baseString)
    signature = uriRfc3986Encode(signature)

    assert_equal("Yh7m15oV0XbRTFP%2Fp4T56sg38QDLKEh4cVK90taaHstE%2FjTdCn53CtbUETQFWLR2VdMMv8ujeewM3NDzLRfVLqwE%2FsWbpeaWtm%2FpffAvHjXFTquo4hBE6CPRNEqFyIjCz4lNaYoeaQMFJVmYfSF2CWn46RP3wmIrfs5IfQNtwUI%3D",signature)

  end


end