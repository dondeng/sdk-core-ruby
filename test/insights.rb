require "mastercard/core/model"

module MasterCard
  module Test
    include MasterCard::Core::Model
    class Insights < BaseObject

      def getResourcePath(action)

        if action.upcase == "QUERY"
          return "/sectorinsights/v1/sectins.svc/insights"
        end

        raise StandardError("Invalid action #{action.to_s}")

      end

      def getHeaderParams(action)

        if action.upcase == "QUERY"
          return []
        end

        raise StandardError("Invalid action #{action.to_s}")

      end

      def self.query(criteria)

        obj = Insights.new(criteria)
        return Insights.queryObject(obj)

      end


    end
  end
end
