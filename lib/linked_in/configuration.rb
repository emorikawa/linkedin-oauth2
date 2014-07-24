module LinkedIn
  class Configuration
    attr_accessor :client_id,
                  :client_secret

    alias_method :api_key, :client_id
    alias_method :secret_key, :client_secret
  end
end
