module LinkedIn
  # Configuration for the LinkedIn gem.
  #
  #     LinkedIn.configure do |config|
  #       config.client_id     = ENV["LINKEDIN_CLIENT_ID"]
  #       config.client_secret = ENV["LINKEDIN_CLIENT_SECRET"]
  #     end
  #
  # The default endpoints for LinkedIn are also stored here.
  #
  # LinkedIn uses the term "API key" to refer to "client id". They also
  # use the term "Secret Key" to refer to "client_secret". We alias those
  # terms in the config.
  #
  # * LinkedIn.config.site = "https://www.linkedin.com"
  # * LinkedIn.config.token_url = "/uas/oauth2/accessToken"
  # * LinkedIn.config.authorize_url = "/uas/oauth2/authorization"
  class Configuration
    attr_accessor :api,
                  :site,
                  :scope,
                  :client_id,
                  :token_url,
                  :api_version,
                  :redirect_uri,
                  :authorize_url,
                  :client_secret,
                  :default_profile_fields

    alias_method :api_key, :client_id
    alias_method :secret_key, :client_secret

    def initialize
      @api = "https://api.linkedin.com"
      @api_version = "/v1"
      @site = "https://www.linkedin.com"
      @token_url = "/uas/oauth2/accessToken"
      @authorize_url = "/uas/oauth2/authorization"
    end
  end
end
