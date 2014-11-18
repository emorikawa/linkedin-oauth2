module LinkedIn

  # Raised when users call a deprecated function
  class Deprecated < StandardError; end

  # Raised when we know requests will be malformed
  class InvalidRequest < StandardError; end
  
  # Raised when we get a throttle error from the API
  class ThrottleError < StandardError; end

  # Raised when LinkedIn returns a non 400+ status code during an OAuth
  # request.
  class OAuthError < OAuth2::Error; end

  # Raised when LinkedIn returns a non 400+ status code during an API
  # request
  class APIError < OAuth2::Error; end

  module ErrorMessages
    class << self
      attr_reader :deprecated,
                  :redirect_uri,
                  :no_auth_code,
                  :no_access_token,
                  :credentials_missing,
                  :redirect_uri_mismatch,
                  :throttled
    end

    @deprecated = "This has been deprecated by LinkedIn. Check https://developer.linkedin.com to see the latest available API calls"

    @redirect_uri = "You must provide a redirect_uri. Set it in LinkedIn.configure or pass it in as the redirect_uri option. It must exactly match the redirect_uri you set on your application's settings page on LinkedIn's website."

    @no_auth_code = "You must provide the authorization code passed to your redirect uri in the url params"

    @no_access_token = "You must have an access token to use LinkedIn's API. Use the LinkedIn::OAuth2 module to obtain an access token"

    @credentials_missing = "Client credentials do not exist. Please either pass your client_id and client_secret to the LinkedIn::Oauth.new constructor or set them via LinkedIn.configure"

    @redirect_uri_mismatch = "Throttle limit for calls to this resource is reached"
    
    def klass
      
    end
    
    
  end
end
