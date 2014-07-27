module LinkedIn
  class Configuration
    attr_accessor :site,
                  :client_id,
                  :token_url,
                  :authorize_url,
                  :client_secret

    alias_method :api_key, :client_id
    alias_method :secret_key, :client_secret

    def initialize
      @site = "https://www.linkedin.com"
      @token_url = "/uas/oauth2/accessToken"
      @authorize_url = "/uas/oauth2/authorization"
    end
  end
end
