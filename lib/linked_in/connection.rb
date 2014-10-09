Faraday::Response.register_middleware :raise_error_orig => Faraday::Response::RaiseError

module LinkedIn
  # Used to perform requests against LinkedIn's API.
  class Connection < ::Faraday::Connection

    def initialize(url=nil, options=nil, &block)

      if url.is_a? Hash
        options = url
        url = options[:url]
      end

      url = default_url if url.nil?

      super url, options, &block

      # We need to use the FlatParamsEncoder so we can pass multiple of
      # the same param to certain endpoints (like the search API).
      self.options.params_encoder = ::Faraday::FlatParamsEncoder

      self.response :raise_error_orig
    end


    private ##############################################################


    def default_url
      LinkedIn.config.api + LinkedIn.config.api_version
    end
  end
end
