module LinkedIn
  # Groups API
  #
  # @see http://developer.linkedin.com/documents/groups-api Groups API
  # @see http://developer.linkedin.com/documents/groups-fields Groups Fields
  #
  # The following API actions do not have corresponding methods in
  # this module
  #
  #   * PUT Change my Group Settings
  #   * POST Change my Group Settings
  #   * DELETE Leave a group
  #   * PUT Follow/unfollow a Group post
  #   * PUT Flag a Post as a Promotion or Job
  #   * DELETE Delete a Post
  #   * DELETE Flag a post as inappropriate
  #   * DELETE A comment or flag comment as inappropriate
  #   * DELETE Remove a Group Suggestion
  #
  # [(contribute here)](https://github.com/emorikawa/linkedin-oauth2)
  class Groups < APIResource
    # Retrieve group suggestions for the current user
    #
    # Permissions: r_fullprofile
    #
    # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
    #
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def group_suggestions(options = {})
      path = "#{profile_path(options)}/suggestions/groups"
      get(path, options)
    end

    # Retrieve the groups a current user belongs to
    #
    # Permissions: rw_groups
    #
    # @see http://developer.linkedin.com/documents/groups-api
    #
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def group_memberships(options = {})
      path = "#{profile_path(options)}/group-memberships"
      get(path, options)
    end

    # Retrieve the profile of a group
    #
    # Permissions: rw_groups
    #
    # @see http://developer.linkedin.com/documents/groups-api
    #
    # @param [Hash] options identifies the group or groups
    # @optio options [String] :id identifier for the group
    # @return [LinkedIn::Mash]
    def group_profile(options)
      path = group_path(options)
      get(path, options)
    end

    # Retrieve the posts in a group
    #
    # Permissions: rw_groups
    #
    # @see http://developer.linkedin.com/documents/groups-api
    #
    # @param [Hash] options identifies the group or groups
    # @optio options [String] :id identifier for the group
    # @optio options [String] :count
    # @optio options [String] :start
    # @return [LinkedIn::Mash]
    def group_posts(options)
      path = "#{group_path(options)}/posts"
      get(path, options)
    end

    # Create a share for a company that the authenticated user
    # administers
    #
    # Permissions: rw_groups
    #
    # @see http://developer.linkedin.com/documents/groups-api#create
    #
    # @param [String] group_id Group ID
    # @macro share_input_fields
    # @return [void]
    def add_group_share(group_id, share)
      path = "/groups/#{group_id}/posts"
      post(path, share)
    end

    # (Update) User joins, or requests to join, a group
    #
    # @see http://developer.linkedin.com/documents/groups-api#membergroups
    #
    # @param [String] group_id Group ID
    # @return [void]
    def join_group(group_id)
      path = "/people/~/group-memberships/#{group_id}"
      body = {'membership-state' => {'code' => 'member' }}
      put(path, body)
    end


    private ##############################################################


    def group_path(options)
      path = "/groups"
      if id = options.delete(:id)
        path += "/#{id}"
      end
    end
  end
end
