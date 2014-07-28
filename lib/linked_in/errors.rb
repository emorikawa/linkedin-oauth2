module LinkedIn
  class LinkedInError < StandardError
    attr_reader :data
    def initialize(data)
      @data = data
      super
    end
  end

  class OAuthError          < StandardError; end
  class GeneralError        < LinkedInError; end
  class NotFoundError       < StandardError; end
  class UnavailableError    < StandardError; end
  class AccessDeniedError   < LinkedInError; end
  class UnauthorizedError   < LinkedInError; end
  class InformLinkedInError < StandardError; end
end
