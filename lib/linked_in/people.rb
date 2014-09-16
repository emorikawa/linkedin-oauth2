require 'time'
module LinkedIn
  # People APIs
  #
  # @see http://developer.linkedin.com/documents/people People API
  # @see http://developer.linkedin.com/documents/profile-fields Profile Fields
  # @see http://developer.linkedin.com/documents/field-selectors Field Selectors
  # @see http://developer.linkedin.com/documents/accessing-out-network-profiles Accessing Out of Network Profiles
  class People < APIResource

    # @!macro multi_profile_options
    #   @options opts [Array]  :urls A list of profile urls
    #   @options opts [Array]  :ids List of LinkedIn IDs
    #
    # @!macro new profile_args
    #   @overload profile()
    #     Fetches your own profile
    #   @overload profile(id_or_url, opts)
    #     Fetches the profile of another user
    #     @param [String] id_or_url a LinkedIn id or a profile URL
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
      get(path, options)
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
      get(path, options)
    end

    # Retrieve a list of the latest set of 1st degree connections for a
    # user
    #
    # Permissions: r_network
    #
    # @see http://developer.linkedin.com/documents/connections-api
    #
    # @param [String, Fixnum, Time] modified_since timestamp in unix time
    #   miliseconds indicating since when you want to retrieve new
    #   connections
    # @param [Hash] opts profile options
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def new_connections(since, options={})
      since = parse_modified_since(since)
      options.merge!('modified' => 'new', 'modified-since' => since)
      path = "#{profile_path(options, false)}/connections"
      get(path, options)
    end

    # Retrieve the picture url
    # http://api.linkedin.com/v1/people/~/picture-urls::(original)
    #
    # Permissions: r_network
    #
    # @options [String] :id, the id of the person for whom you want the profile picture
    # @options [String] :picture_size, default: 'original'
    # @options [String] :secure, default: 'false', options: ['false','true']
    #
    # example for use in code: client.picture_urls(:id => 'id_of_connection')
    def picture_urls(options={})
      picture_size = options.delete(:picture_size) || 'original'
      path = "#{profile_path(options)}/picture-urls::(#{picture_size})"
      get(path, options)
    end

    # Retrieve the skills
    #
    # Permissions: r_fullprofile
    def skills(id={}, options={})
      options = parse_id(id, options)
      path = "#{profile_path(options, false)}/skills"
      get(path, options)
    end     


    protected ############################################################


    def get(path, options)
      options[:"secure-urls"] = true unless options[:secure] == false
      super path, options
    end


    private ##############################################################


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

    # Returns a unix time in miliseconds
    def parse_modified_since(since)
      if since.is_a? ::Fixnum
        if ::Time.at(since).year < 2050
          # Got passed in as seconds.
          since = since * 1000
        end
      elsif since.is_a? ::String
        since = utc_parse(since)
      elsif since.is_a? ::Time
        since = since.to_i * 1000
      end
      return since
    end

    def utc_parse(since)
      t = ::Time.parse(since)
      Time.utc(t.year, t.month, t.day, t.hour, t.min, t.sec).to_i * 1000
    end

  end
end
