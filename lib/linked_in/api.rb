module LinkedIn
  class API

    attr_accessor :access_token

    def initialize(access_token=nil)
      access_token = parse_access_token(access_token)
      verify_access_token!(access_token)
      @access_token = access_token

      @connection = LinkedIn::Connection.new params: default_params,
                                             headers: default_headers

      initialize_endpoints
    end

    extend Forwardable # Composition over inheritance
    def_delegators :@people, :profile,
                             :connections,
                             :picture_urls,
                             :new_connections

    private ##############################################################


    def default_params
      # https://developer.linkedin.com/documents/authentication
      return {oauth2_access_token: @access_token.token}
    end

    def default_headers
      # https://developer.linkedin.com/documents/api-requests-json
      return {"x-li-format" => "json"}
    end

    def initialize_endpoints
      @people = LinkedIn::People.new(@connection)
    end

    def verify_access_token!(access_token)
      if not access_token.is_a? LinkedIn::AccessToken
        raise no_access_token_error
      end
    end

    def parse_access_token(access_token)
      if access_token.is_a? LinkedIn::AccessToken
        return access_token
      elsif access_token.is_a? String
        return LinkedIn::AccessToken.new(access_token)
      end
    end

    def no_access_token_error
      msg = LinkedIn::ErrorMessages.no_access_token
      LinkedIn::InvalidRequest.new(msg)
    end
  end
end
