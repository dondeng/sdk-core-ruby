require 'minitest/autorun'

class BaseTest < Minitest::Test

    @responses = Hash.new

    def self.putResponse(name, response)
        @responses[name] = response
    end

    def self.resolveResponseValue(overrideValue)
        pos = overrideValue.index('.')

        name = overrideValue[0..pos-1]
        puts "Example Name: %s" % name

        key = overrideValue[pos+1..overrideValue.length]
        puts "Key Name: %s" % key

        if @responses.key?(name)
            response = @responses[name].getObject()
            if response.key?(key)
                return response[key]
            else
                puts "Key:'%s' is not found in the response" % key
            end
        else
            puts "Example:'%s' is not found in the response" % name
        end

        return nil
    end

    def assertEqual(ignoreAsserts,key,actualValue,expectedValue)
        if !ignoreAsserts.include?(key)
            assert_equal(expectedValue, actualValue)
        end
    end

end