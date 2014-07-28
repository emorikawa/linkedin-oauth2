module LinkedIn
  class API
    attr_accessor :access_token

    def initialize(access_token=nil)
      @access_token = access_token
      verify_access_token!
    end


    private ##############################################################


    def verify_access_token!
      if self.access_token.nil?
        raise no_access_token_error
      end
    end

    def no_access_token_error
      msg = LinkedIn::ErrorMessages.no_access_token
      LinkedIn::InvalidRequest.new(msg)
    end
  end
end
