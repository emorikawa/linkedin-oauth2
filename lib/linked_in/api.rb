module LinkedIn
  class API

    attr_accessor :access_token

    def initialize(access_token=nil)
      access_token = parse_access_token(access_token)
      verify_access_token!(access_token)
      @access_token = access_token

      @connection = LinkedIn::Connection.new params: default_params,
                                             headers: default_headers

      initialize_endpoints
    end

    extend Forwardable # Composition over inheritance
    def_delegators :@jobs, :job,
                           :job_bookmarks,
                           :job_suggestions,
                           :add_job_bookmark

    def_delegators :@people, :profile,
                             :skills,
                             :connections,
                             :picture_urls,
                             :new_connections

    def_delegators :@search, :search

    def_delegators :@groups, :join_group,
                             :group_posts,
                             :group_profile,
                             :add_group_share,
                             :group_suggestions,
                             :group_memberships,
                             :post_group_discussion

    def_delegators :@companies, :company,
                                :company_search,
                                :follow_company,
                                :company_updates,
                                :unfollow_company,
                                :add_company_share,
                                :company_statistics,
                                :company_historical_follow_statistics,
                                :company_historical_status_update_statistics,
                                :company_updates_likes,
                                :company_updates_comments

    def_delegators :@communications, :send_message

    def_delegators :@share_and_social_stream, :shares,
                                              :share,
                                              :add_share,
                                              :like_share,
                                              :share_likes,
                                              :unlike_share,
                                              :share_comments,
                                              :update_comment,
                                              :network_updates

    private ##############################################################

    def initialize_endpoints
      @jobs = LinkedIn::Jobs.new(@connection)
      @people = LinkedIn::People.new(@connection)
      @search = LinkedIn::Search.new(@connection)
      @groups = LinkedIn::Groups.new(@connection)
      @companies = LinkedIn::Companies.new(@connection)
      @communications = LinkedIn::Communications.new(@connection)
      @share_and_social_stream = LinkedIn::ShareAndSocialStream.new(@connection)
    end

    def default_params
      # https//developer.linkedin.com/documents/authentication
      return {oauth2_access_token: @access_token.token}
    end

    def default_headers
      # https://developer.linkedin.com/documents/api-requests-json
      return {"x-li-format" => "json"}
    end

    def verify_access_token!(access_token)
      if not access_token.is_a? LinkedIn::AccessToken
        raise no_access_token_error
      end
    end

    def parse_access_token(access_token)
      if access_token.is_a? LinkedIn::AccessToken
        return access_token
      elsif access_token.is_a? String
        return LinkedIn::AccessToken.new(access_token)
      end
    end

    def no_access_token_error
      msg = LinkedIn::ErrorMessages.no_access_token
      LinkedIn::InvalidRequest.new(msg)
    end
  end
end
