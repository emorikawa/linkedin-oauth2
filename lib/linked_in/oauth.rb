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

      if self.options[:raise_errors]
        check_credentials!(client_id, client_secret)
      end
    end

    def auth_code_url(options={})
      options = default_auth_code_url_options(options)

      if self.options[:raise_errors]
        check_auth_code_url!(options)
      end

      self.auth_code.authorize_url(options)
    end

    private ##############################################################

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

    def check_auth_code_url!(options={})
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
      msg = LinkedIn::ErrorMessages.redirect_uri
      LinkedIn::InvalidRequest.new(msg)
    end

    def credential_error
      msg = LinkedIn::ErrorMessages.credentials_missing
      LinkedIn::InvalidRequest.new(msg)
    end
  end
end
