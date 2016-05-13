module MasterCard
  module Security
    class Authentication

      def signRequest(uri,request)
        raise NotImplementedError.new("This method should be overridden by the class")
      end
    end
  end
end
