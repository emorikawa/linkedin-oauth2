module LinkedIn
  class InvalidRequest < StandardError; end

  module ErrorMessages
    class << self
      attr_reader :redirect_uri,
                  :no_access_token,
                  :credentials_missing
    end

    @redirect_uri = "You must provide a redirect_uri to get your auth_code_uri. Set it in LinkedIn.configure or pass it in as the redirect_uri option. It must exactly match the redirect_uri you set on your application's settings page on LinkedIn's website."

    @no_access_token = "You must have an access token to use LinkedIn's API. Use the LinkedIn::OAuth2 module to obtain an access token"

    @credentials_missing = "Client credentials do not exist. Please either pass your client_id and client_secret to the LinkedIn::Oauth.new constructor or set them via LinkedIn.configure"
  end

  # class LinkedInError < StandardError
  #   attr_reader :data
  #   def initialize(data)
  #     @data = data
  #     super
  #   end
  # end

  # class GeneralError        < LinkedInError; end
  # class NotFoundError       < StandardError; end
  # class UnavailableError    < StandardError; end
  # class AccessDeniedError   < LinkedInError; end
  # class UnauthorizedError   < LinkedInError; end
  # class InformLinkedInError < StandardError; end
end
