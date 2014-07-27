module LinkedIn
  class OAuth2 < ::OAuth2::Client
    def initialize(client_id=LinkedIn.config.client_id,
                   client_secret=LinkedIn.config.client_secret,
                   options = {}, &block)

      if client_id.is_a? Hash
        options = client_id
        client_id = LinkedIn.config.client_id
      end

      check_credentials!(client_id, client_secret)

      options = default_oauth_options(options)

      super client_id, client_secret, options, &block
    end

    private ##############################################################

    def default_oauth_options(custom_options={})
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

    def credential_error
      msg = "Client credentials do not exist. Please either pass your client_id and client_secret to the LinkedIn::Oauth.new constructor or set them via LinkedIn.configure"
      LinkedIn::Errors::GeneralError.new(msg)
    end
  end
end
