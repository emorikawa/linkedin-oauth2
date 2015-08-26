require 'faraday'

module LinkedIn
  class RaiseError < Faraday::Response::RaiseError
    def on_complete(response)
      status_code = response.status.to_i
      parsed_response = Mash.from_response(response)
      case status_code
        when 401
          raise LinkedIn::Errors::UnauthorizedError.new(parsed_response), "(#{parsed_response.status}): #{parsed_response.message}"
        when 400
          raise LinkedIn::Errors::GeneralError.new(parsed_response), "(#{parsed_response.status}): #{parsed_response.message}"
        when 403
          raise LinkedIn::Errors::AccessDeniedError.new(parsed_response), "(#{parsed_response.status}): #{parsed_response.message}"
        when 404
          raise LinkedIn::Errors::NotFoundError, "(#{parsed_response.status}): #{parsed_response.message}"
        when 500
          raise LinkedIn::Errors::InformLinkedInError, "LinkedIn had an internal error. Please let them know in the forum."
        when 502..503
          raise LinkedIn::Errors::UnavailableError, "(#{parsed_response.status}): #{parsed_response.message}"
        else
          super
      end
    end
  end
end

Faraday::Response.register_middleware :linkedin_raise_error => LinkedIn::RaiseError
