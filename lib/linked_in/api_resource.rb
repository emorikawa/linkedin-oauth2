module LinkedIn
  # The abstract class all API endpoints inherit from. Providers common
  # builder methods across all endpoints.
  class APIResource

    attr_reader :connection

    def initialize
      @connection = LinkedIn::Connection.new
    end

    protected ############################################################

    def simple_query(path, options={})
      fields = options.delete(:fields) || LinkedIn.config.default_profile_fields

      if options.delete(:public)
        path +=":public"
      elsif fields
        path +=":(#{build_fields_params(fields)})"
      end

      headers = options.delete(:headers) || {}

      response = @connection.get(path, params, headers)

      Mash.from_json(response)
    end

    private ##############################################################

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
