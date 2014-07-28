module LinkedIn
  # A simple data object to contain the token string and expiration data.
  class AccessToken
    attr_accessor :token, :expires_in, :expires_at

    # Creates a simple data wrapper for an access token.
    #
    # LinkedIn returns only an `expires_in` value. This calculates and
    # sets and `expires_at` field for convenience.
    #
    # @param [String] token the access token
    # @param [FixNum] expires_in number of seconds the token lasts for
    # @param [Time] expires_at when the token will expire.
    def initialize(token=nil, expires_in=nil, expires_at=nil)
      self.token = token
      self.expires_in = expires_in
      if expires_at.nil? and not self.expires_in.nil?
        self.expires_at = Time.now + expires_in
      else
        self.expires_at = expires_at
      end
    end
  end
end
