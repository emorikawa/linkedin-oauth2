module LinkedIn
  # The abstract class all API endpoints inherit from. Providers common
  # builder methods across all endpoints.
  class APIResource

    def initialize(connection)
      @connection = connection
    end

    protected ############################################################

    def get(path, options={})
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
      path += generate_field_selectors(options)

      headers = options.delete(:headers) || {}

      params = format_options_for_query(options)

      return [path, params, headers]
    end

    # Dasherizes the param keys
    def format_options_for_query(options)
      options.reduce({}) do |list, kv|
        key, value = kv.first.to_s.gsub("_","-"), kv.last
        list[key]  = value
        list
      end
    end
    def generate_field_selectors(options)
      default = LinkedIn.config.default_profile_fields || {}
      fields = options.delete(:fields) || default

      if options.delete(:public)
        return ":public"
      elsif fields.empty?
        return ""
      else
        return ":(#{build_fields_params(fields)})"
      end
    end

    def build_fields_params(fields)
      if fields.is_a?(Hash) && !fields.empty?
        fields.map {|i,v| "#{i}:(#{build_fields_params(v)})" }.join(',')
      elsif fields.respond_to?(:each)
        fields.map {|field| build_fields_params(field) }.join(',')
      else
        fields.to_s.gsub("_", "-")
      end
    end
  end
end
