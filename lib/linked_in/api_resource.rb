module LinkedIn
  # The abstract class all API endpoints inherit from. Providers common
  # builder methods across all endpoints.
  class APIResource

    def initialize(connection)
      @connection = connection
    end

    protected ############################################################

    def simple_query(path, options={})
      url, params, headers = prepare_connection_params(path, options)

      response = @connection.get(url, params, headers)

      return Mash.from_json(response.body)
    end

    def deprecated
      LinkedIn::Deprecated.new(LinkedIn::ErrorMessages.deprecated)
    end

    private ##############################################################

    def prepare_connection_params(path, options)
      path = @connection.path_prefix + path

      default = LinkedIn.config.default_profile_fields
      fields = options.delete(:fields) || default

      if options.delete(:public)
        path +=":public"
      elsif fields
        path +=":(#{build_fields_params(fields)})"
      end

      headers = options.delete(:headers) || {}

      return [path, options, headers]
    end

    def build_fields_params(fields)
      if fields.is_a?(Hash) && !fields.empty?
        fields.map {|index,value| "#{index}:(#{build_fields_params(value)})" }.join(',')
      elsif fields.respond_to?(:each)
        fields.map {|field| build_fields_params(field) }.join(',')
      else
        fields.to_s.gsub("_", "-")
      end
    end
  end
end
