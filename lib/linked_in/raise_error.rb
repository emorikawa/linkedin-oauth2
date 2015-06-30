require 'faraday'

module LinkedIn
  class RaiseError < Faraday::Response::RaiseError
    def on_complete(response)
      status_code = response.status.to_i
      if status_code == 403 && response.body =~ /throttle/i
        fail LinkedIn::ThrottleError
      elsif [400,403].include?(status_code)
        body = MultiJson.load(response.body)

        if status_code == 400 && response.body =~ /is missing/i        
          fail LinkedIn::ArgumentError, body['message'] || LinkedIn::ErrorMessages.argument_missing
        elsif status_code == 400
          fail LinkedIn::InvalidRequest, body['message'] || LinkedIn::ErrorMessages.arguments_malformed
        else # status_code == 403
          fail LinkedIn::PermissionsError, body['message'] || LinkedIn::ErrorMessages.not_permitted
        end
      else
        super
      end
    end
  end
end

Faraday::Response.register_middleware :linkedin_raise_error => LinkedIn::RaiseError
