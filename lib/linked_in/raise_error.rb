require 'faraday'

module LinkedIn
  class RaiseError < Faraday::Response::RaiseError
    def on_complete(response)
      data = Mash.from_json(response.body)
      case response.status.to_i
      when 400
        raise LinkedIn::InvalidRequest.new(data), "(#{data.status}): #{data.message}"
      when 401
        raise LinkedIn::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
      when 403
        raise LinkedIn::AccessDeniedError.new(data), "(#{data.status}): #{data.message}"
      when 404
        raise LinkedIn::NotFoundError.new(data), "(#{data.status}): #{data.message}"
      when 500
        raise LinkedIn::InformLinkedInError.new(data),
          "LinkedIn had an internal error. Please let them know in the forum. (#{data.status}): #{data.message}"
      when 502..503
        raise LinkedIn::UnavailableError.new(data), "(#{data.status}): #{data.message}"
      else
        super
      end
    end
  end
end

Faraday::Response.register_middleware :linkedin_raise_error => LinkedIn::RaiseError
