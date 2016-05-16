require "minitest/autorun"
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

  def test_execute

=begin
    input = {

        "Content-Type"=>"application/json",
        "a"=>1,
        "b"=>"naman aggarwal %20",
        "id"=>3
    }

    header = ["Content-Type"]

    action = "list"
    resourcePath = "/user/{a}"
    Config.setLocal(true)
    Config.setDebug(true)
    cont = APIController.new
    cont.execute(action,resourcePath,header,input)
    Config.setLocal(false)
    Config.setDebug(false)
=end

  input = {

    "Period" => "",
    "CurrentRow" => "1",
    "Sector" => "",
    "Offset" => "25",
    "Country" => "US",
    "Ecomm" => ""
  }

  action = "query"

  resourcePath = "/sectorinsights/v1/sectins.svc/insights"

  header = []

  @controller.execute(action,resourcePath,header,input)

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
