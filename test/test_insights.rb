require 'minitest/autorun'
require 'insights'
require 'mastercard/security/oauth'
require 'mastercard/core/model'


class InsightsTest < Minitest::Test
  include MasterCard::Security::OAuth
  include MasterCard::Core
  include MasterCard::Core::Model
  include MasterCard::Test

  def setup
    keyFile =  File.join(File.dirname(__FILE__), "resources", "prod_key.p12")
    @auth = OAuth::OAuthAuthentication.new("gVaoFbo86jmTfOB4NUyGKaAchVEU8ZVPalHQRLTxeaf750b6!414b543630362f426b4f6636415a5973656c33735661383d",keyFile, "alias", "password")
    Config.setAuthentication(@auth)
  end

  def test_example_insights

    mapObj = BaseMap.new

    mapObj.set("Period","")
    mapObj.set("CurrentRow","1")
    mapObj.set("Sector","")
    mapObj.set("Offset","25")
    mapObj.set("Country","US")
    mapObj.set("Ecomm","")


    response = Insights.query(mapObj)

    assert_equal("70",response.get("SectorRecordList.Count"))
    assert_equal("Success",response.get("SectorRecordList.Message"))


  end

end
