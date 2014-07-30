module LinkedIn
  # The abstract class all API endpoints inherit from. Providers common
  # builder methods across all endpoints.
  #
  # @!macro profile_options
  #   @options opts [String] :id LinkedIn ID to fetch profile for
  #   @options opts [String] :url The profile url
  #   @options opts [String] :lang Requests the language of the profile.
  #     Options are: en, fr, de, it, pt, es
  #   @options opts [Array, Hash] :fields fields to fetch. The list of
  #     fields can be found at
  #     https://developer.linkedin.com/documents/profile-fields
  #   @options opts [String] :secure (true) specify if urls in the
  #     response should be https
  #   @options opts [String] :"secure-urls" (true) alias to secure option
  #
  # @!macro share_input_fields
  #   @param [Hash] share content of the share
  #   @option share [String] :comment
  #   @option share [String] :content
  #   @option share [String] :title
  #   @option share [String] :submitted-url
  #   @option share [String] :submitted-image-url
  #   @option share [String] :description
  #   @option share [String] :visibility
  #   @option share [String] :code
  #
  # @!macro company_path_options
  #   @param [Hash] options identifies the user profile you want
  #   @option options [String] :domain company email domain
  #   @option options [String] :id company ID
  #   @option options [String] :url
  #   @option options [String] :name company universal name
  #   @option options [String] :is_admin list all companies that the
  #     authenticated is an administrator of
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

    def post(path=nil, body=nil, headers=nil, &block)
      @connection.post(prepend_prefix(path), body, headers, &block)
    end

    def put(path=nil, body=nil, headers=nil, &block)
      @connection.put(prepend_prefix(path), body, headers, &block)
    end

    def delete(path=nil, params=nil, headers=nil, &block)
      @connection.delete(prepend_prefix(path), params, headers, &block)
    end

    def deprecated
      LinkedIn::Deprecated.new(LinkedIn::ErrorMessages.deprecated)
    end

    private ##############################################################

    def prepend_prefix(path)
      return @connection.path_prefix + path
    end

    def prepare_connection_params(path, options)
      path = prepend_prefix(path)
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

    def profile_path(options={}, allow_multiple=true)
      path = "/people"

      id = options.delete(:id)
      url = options.delete(:url)

      ids = options.delete(:ids)
      urls = options.delete(:urls)

      if options.delete(:email) then raise deprecated end

      if (id or url)
        path += single_person_path(id, url)
      elsif allow_multiple and (ids or urls)
        path += multiple_people_path(ids, urls)
      else
        path += "/~"
      end
    end

    def single_person_path(id=nil, url=nil)
      if id
        return "/id=#{id}"
      elsif url
        return "/url=#{CGI.escape(url)}"
      else
        return "/~"
      end
    end

    # See syntax here: https://developer.linkedin.com/documents/field-selectors
    def multiple_people_path(ids=[], urls=[])
      if ids.nil? then ids = [] end
      if urls.nil? then urls = [] end

      ids = ids.map do |id|
        if is_self(id) then "~" else "id=#{id}" end
      end
      urls = urls.map do |url|
        if is_self(url) then "~" else "url=#{CGI.escape(url)}" end
      end
      return "::(#{(ids+urls).join(",")})"
    end

    def is_self(str)
      str == "self" or str == "~"
    end
  end
end
