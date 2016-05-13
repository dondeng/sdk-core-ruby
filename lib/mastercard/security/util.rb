module MasterCard
  module Security
    module Util
      extend self
      
      def getTimestamp()
        #
        # Returns the UTC timestamp (seconds passed since epoch)
        return Time.now.getutc.to_i
      end

      def getNonce(len = 16)
        # Returns a random string of length=len
        o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
        return (0...len).map { o[rand(o.length)] }.join
      end

    end
  end
end
