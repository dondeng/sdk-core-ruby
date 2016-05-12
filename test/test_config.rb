require 'minitest/autorun'
require 'mastercard/core/config'

class ConfigTest < Minitest::Test
  include MasterCard::Core

  def setup

    Config.setLocal(false)
    Config.setSandbox(true)
  end

  def test_config_get_url

    url = Config.getAPIBaseURL()
    assert_equal(Constants::API_BASE_SANDBOX_URL,url)

  end

  def test_set_local

    Config.setLocal(true)
    url = Config.getAPIBaseURL()
    assert_equal(Constants::API_BASE_LOCALHOST_URL,url)
    assert(Config.getLocal())
  end


end
