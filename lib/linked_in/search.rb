module LinkedIn
  # Search APIs
  #
  # @see https://developer.linkedin.com/documents/people-search-api
  # @see https://developer.linkedin.com/documents/company-search
  # @see https://developer.linkedin.com/documents/job-search-api
  class Search < APIResource
    # Search through People, Companies, and Jobs
    #
    # To search through people you need to be part of LinkedIn's Vetted
    # API Access Program.
    #
    # @see https://developer.linkedin.com/documents/people-search-api
    #
    # You can use the same API to search through Companies and Jobs.
    #
    # @!macro search_options
    #   @options opts [String] :type either "people", "company", or
    #     "job"
    #   @options opts [String] :keywords various keywords to search for
    #   @options opts [Array, Hash] :fields fields to fetch. The
    #     list of fields can be found at
    #     https://developer.linkedin.com/documents/field-selectors
    #   @options opts various There are many more options you can search
    #     by see https://developer.linkedin.com/documents/people-search-api
    #     for more possibilities. All keys can be entered underscored and
    #     they will be dasherized to match the field names on LinkedIn's
    #     website
    #
    # @overload search
    #   Grabs all people in your network
    # @overload search(keyword_string)
    #   Keyword search through people
    #   @param [String] keywords search keywords
    # @overload search(keyword_string, type)
    #   Keyword search through people
    #   @param [String] keywords search keywords
    #   @param [String] type either "people", "company", or "job"
    # @overload search(opts)
    #   Searches based on various options
    #   @param [Hash] opts search options
    #   @macro search_options
    # @overload search(opts, type)
    #   Searches for a type based on various options
    #   @param [Hash] opts search options
    #   @macro search_options
    #   @param [String] type either "people", "company", or "job"
    def search(options={}, type='people')
      options, type = prepare_options(options, type)
      path = "/#{type.to_s}-search"
      get(path, options)
    end

    private ##############################################################

    def prepare_options(options, type)
      options ||= {}
      if options.is_a? String or options.is_a? Array
        kw = options
        options = {keywords: kw}
      end

      if not options[:type].nil?
        type = options.delete(:type)
      end

      return [options, type]
    end
  end
end
