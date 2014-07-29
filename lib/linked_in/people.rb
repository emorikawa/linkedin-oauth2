module LinkedIn
  # People APIs
  #
  # @see http://developer.linkedin.com/documents/people People API
  # @see http://developer.linkedin.com/documents/profile-fields Profile Fields
  # @see http://developer.linkedin.com/documents/field-selectors Field Selectors
  # @see http://developer.linkedin.com/documents/accessing-out-network-profiles Accessing Out of Network Profiles
  class People < APIResource

    # @!macro profile_options
    #   @options opts [String] :id LinkedIn ID to fetch profile for
    #   @options opts [String] :url The profile url
    #   @options opts [String] :lang Requests the language of the profile.
    #     Options are: en, fr, de, it, pt, es
    #   @options opts [Array]  :fields An array of fields to fetch. The
    #     list of fields can be found at
    #     https://developer.linkedin.com/documents/profile-fields
    #   @options opts [String] :secure (true) specify if urls in the
    #     response should be https
    #   @options opts [String] :"secure-urls" (true) alias to secure option
    #
    # @!macro multi_profile_options
    #   @options opts [Array]  :urls A list of profile urls
    #   @options opts [Array]  :ids List of LinkedIn IDs
    #
    # @!macro new profile_args
    #   @overload profile()
    #     Fetches your own profile
    #   @overload profile(id_or_url, opts)
    #     Fetches the profile of another user
    #     @param [String]
    #     @param [Hash] opts more profile options
    #     @macro profile_options
    #   @overload profile(opts)
    #     Fetches the profile of another user
    #     @param [Hash] opts profile options
    #     @macro profile_options
    #   @return [LinkedIn::Mash]

    # Retrieve a member's LinkedIn profile.
    #
    # Required permissions: r_basicprofile, r_fullprofile
    #
    # @see http://developer.linkedin.com/documents/profile-api
    # @macro profile_args
    # @macro multi_profile_options
    def profile(id={}, options={})
      options = parse_id(id, options)
      path = profile_path(options)
      simple_query(path, options)
    end

    # Retrieve a list of 1st degree connections for a user who has
    # granted access to his/her account
    #
    # Permissions: r_network
    #
    # @see http://developer.linkedin.com/documents/connections-api
    # @macro profile_args
    def connections(id={}, options={})
      options = parse_id(id, options)
      path = "#{profile_path(options, false)}/connections"
      simple_query(path, options)
    end

    # Retrieve a list of the latest set of 1st degree connections for a
    # user
    #
    # Permissions: r_network
    #
    # @see http://developer.linkedin.com/documents/connections-api
    #
    # @param [String, FixNum, Time] modified_since timestamp in unix time
    #   miliseconds indicating since when you want to retrieve new
    #   connections
    # @param [Hash] opts profile options
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def new_connections(modified_since, options={})
      options.merge!('modified' => 'new', 'modified-since' => modified_since)
      path = "#{profile_path(options, false)}/connections"
      simple_query(path, options)
    end

    # @deprecated No longer in the LinkedIn API People docs
    #
    # Retrieve the picture url
    # http://api.linkedin.com/v1/people/~/picture-urls::(original)
    #
    # Permissions: r_network
    #
    # @options [String] :id, the id of the person for whom you want the
    #   profile picture
    # @options [String] :picture_size, default: 'original'
    # @options [String] :secure, default: 'false', options: ['false','true']
    #
    # example for use in code: client.picture_urls(:id => 'id_of_connection')
    def picture_urls(options={})
      raise deprecated
      picture_size = options.delete(:picture_size) || 'original'
      path = "#{picture_urls_path(options)}::(#{picture_size})"
      simple_query(path, options)
    end


    private ############################################################


    def parse_id(id, options)
      if id.is_a? String
        if id.downcase =~ /linkedin\.com/
          options[:url] = id
        else
          options[:id] = id
        end
      elsif id.is_a? Hash
        options = id
      else
        options = {}
      end

      return options
    end

    def profile_path(options={}, allow_multiple=true)
      path = "/people"

      ids = options.delete(:ids)
      urls = options.delete(:urls)

      if id = options.delete(:id)
        path += "/id=#{id}"
      elsif url = options.delete(:url)
        path += "/url=#{CGI.escape(url)}"
      elsif allow_multiple and (ids or urls)
        path += multiple_people_path(ids, urls)
      elsif options.delete(:email)
        # path += "::(#{email})"
        raise deprecated
      else
        path += "/~"
      end
    end

    # See syntax here: https://developer.linkedin.com/documents/field-selectors
    def multiple_people_path(ids=[], urls=[])
      ids = ids.map do |id|
        if (id == "self" or id == "~") then "~" else "id=#{id}" end
      end
      urls = urls.map {|url| "url=#{CGI.escape(url)}"}
      return "::(#{(ids+urls).join(",")})"
    end

    def picture_urls_path(options)
      path = profile_path(options)
      path += "/picture-urls"
    end

  end
end
