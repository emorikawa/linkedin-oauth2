module LinkedIn
  # The LinkedIn::OAuth2::Client class. Inherits directly from [intreda/oauth2](https://github.com/intridea/oauth2)'s `OAuth2::Client`
  #
  # LinkedIn::OAuth2 sets the following default options:
  #
  # * site = "https://www.linkedin.com"
  # * token_url = "/uas/oauth2/accessToken"
  # * authorize_url = "/uas/oauth2/authorization"
  #
  # More details on LinkedIn's Authorization process can be found here: https://developer.linkedin.com/documents/authentication
  class OAuth2 < ::OAuth2::Client

    attr_accessor :access_token

    # Instantiate a new OAuth 2.0 client using the
    # Client ID and Client Secret registered to your
    # application.
    #
    # You should set the client_id and client_secret in the config.
    #
    #     LinkedIn.configure do |config|
    #       config.client_id     = ENV["LINKEDIN_CLIENT_ID"]
    #       config.client_secret = ENV["LINKEDIN_CLIENT_SECRET"]
    #     end
    #
    # This will let you initialize with zero arguments.
    #
    # If you have already set the `client_id` and `client_secret` in your
    # config, the first and only argument can be the `options` hash.
    #
    # @param [String] client_id the client_id value
    # @param [String] client_secret the client_secret value
    # @param [Hash] opts the options to create the client with
    # @option opts [Symbol] :token_method (:post) HTTP method to use to
    #   request token (:get or :post)
    # @option opts [Hash] :connection_opts ({}) Hash of connection options 
    #   to pass to initialize Faraday with
    # @option opts [FixNum] :max_redirects (5) maximum number of redirects 
    #   to follow
    # @option opts [Boolean] :raise_errors (true) whether or not to raise 
    #   an OAuth2::Error on responses with 400+ status codes
    # @yield [builder] The Faraday connection builder
    def initialize(client_id=LinkedIn.config.client_id,
                   client_secret=LinkedIn.config.client_secret,
                   options = {}, &block)

      if client_id.is_a? Hash
        options = client_id
        client_id = LinkedIn.config.client_id
      end

      options = default_oauth_options(options)

      super client_id, client_secret, options, &block

      @redirect_uri = options[:redirect_uri]

      if self.options[:raise_errors]
        check_credentials!(client_id, client_secret)
      end
    end

    def auth_code_url(options={})
      options = default_auth_code_url_options(options)

      if self.options[:raise_errors]
        check_redirect_uri!(options)
      end

      @redirect_uri = options[:redirect_uri]

      self.auth_code.authorize_url(options)
    end

    def get_access_token(code=nil, options={})
      check_for_code!(code)
      options = default_access_code_options(options)

      if self.options[:raise_errors]
        check_access_code_url!(options)
      end

      token_obj = self.auth_code.get_token(code, options)
      self.access_token = token_obj
      return token_obj.token
    end

    private ##############################################################

    def default_access_code_options(custom_options={})
      custom_options ||= {}
      options = {raise_errors: true}

      @redirect_uri = LinkedIn.config.redirect_uri if @redirect_uri.nil?
      options[:redirect_uri] = @redirect_uri

      options = options.merge custom_options
      return options
    end

    def default_auth_code_url_options(custom_options={})
      custom_options ||= {}
      options = {raise_errors: true}

      if not LinkedIn.config.redirect_uri.nil?
        options[:redirect_uri] = LinkedIn.config.redirect_uri
      end
      if not LinkedIn.config.scope.nil?
        options[:scope] = LinkedIn.config.scope
      end

      options = options.merge custom_options

      if options[:state].nil?
        options[:state] = generate_csrf_token
      end

      return options
    end

    def generate_csrf_token
      SecureRandom.base64(32)
    end

    def check_access_code_url!(options={})
      check_redirect_uri!(options)
      if options[:redirect_uri] != @redirect_uri
        raise redirect_uri_mismatch
      end
    end

    def check_for_code!(code)
      if code.nil?
        msg = ErrorMessages.no_auth_code
        raise InvalidRequest.new(msg)
      end
    end

    def check_redirect_uri!(options={})
      if options[:redirect_uri].nil?
        raise redirect_uri_error
      end
    end

    def default_oauth_options(custom_options={})
      custom_options ||= {}
      options = {}
      options[:site] = LinkedIn.config.site
      options[:token_url] = LinkedIn.config.token_url
      options[:authorize_url] = LinkedIn.config.authorize_url
      return options.merge custom_options
    end

    def check_credentials!(client_id, client_secret)
      if client_id.nil? or client_secret.nil?
        raise credential_error
      end
    end

    def redirect_uri_error
      InvalidRequest.new ErrorMessages.redirect_uri
    end

    def credential_error
      InvalidRequest.new ErrorMessages.credentials_missing
    end

    def redirect_uri_mismatch
      InvalidRequest.new ErrorMessages.redirect_uri_mismatch
    end
  end
end
