module LinkedIn
  # Companies API
  #
  # @see http://developer.linkedin.com/documents/companies Companies API
  # @see http://developer.linkedin.com/documents/company-lookup-api-and-fields Company Fields
  #
  # The following API actions do not have corresponding methods in
  # this module
  #
  #   * Permissions Checking Endpoints for Company Shares
  #   * GET Suggested Companies to Follow
  #   * GET Company Products
  #
  # [(contribute here)](https://github.com/emorikawa/linkedin-oauth2)
  class Companies < APIResource

    # Retrieve a Company Profile
    #
    # @see http://developer.linkedin.com/documents/company-lookup-api-and-fields
    #
    # @macro company_path_options
    # @option options [String] :scope
    # @option options [String] :type
    # @option options [String] :count
    # @option options [String] :start
    # @return [LinkedIn::Mash]
    def company(options = {})
      path = company_path(options)
      get(path, options)
    end

    # Perform a name-based Company search sorted by relevance
    #
    # @see https://developer-programs.linkedin.com/documents/company-search
    #
    # @macro company_path_options
    # @option options [String] :scope
    # @option options [String] :type
    # @option options [String] :count
    # @option options [String] :start
    # @return [LinkedIn::Mash]
    def company_search(options = {})
      path = "/company-search:(companies:(id,name,universal-name,website-url,logo-url,square_logo_url))?keywords=#{CGI.escape(options[:keyword])}&sort=relevance"
      # binding.pry
      results = get(path, options)
      # binding.pry
    end

    # Retrieve a feed of event items for a Company
    #
    # @see http://developer.linkedin.com/reading-company-shares
    #
    # @macro company_path_options
    # @option options [String] :event-type
    # @option options [String] :count
    # @option options [String] :start
    # @return [LinkedIn::Mash]
    def company_updates(options={})
      path = "#{company_path(options)}/updates"
      get(path, options)
    end

    # Retrieve statistics for a particular company page
    #
    # Permissions: rw_company_admin
    #
    # @see http://developer.linkedin.com/documents/company-statistics
    #
    # @macro company_path_options
    # @return [LinkedIn::Mash]
    def company_statistics(options={})
      path = "#{company_path(options)}/company-statistics"
      get(path, options)
    end

    # Retrieve historical statistics about followers for a particular company page
    #
    # Permissions: rw_company_admin
    #
    # @see http://developer.linkedin.com/historical-company-statistics#historicalfollowerstatistics
    #
    # @macro company_path_options
    # @option options [String] :start-timestamp
    # @option options [String] :end-timestamp
    # @option options [String] :time-granularity
    # @return [LinkedIn::Mash]
    def company_historical_follow_statistics(options = {})
      path = "#{company_path(options)}/historical-follow-statistics"
      get(path, options)
    end

    # Retrieve historical statistics about followers for a particular company page
    #
    # Permissions: rw_company_admin
    #
    # @see https://developer.linkedin.com/historical-company-statistics#historicalupdatestatistics
    #
    # @macro company_path_options
    # @option options [String] :start-timestamp
    # @option options [String] :end-timestamp
    # @option options [String] :time-granularity
    # @option options [String] :update-key
    # @option options [Array]  :fields
    # @return [LinkedIn::Mash]
    def company_historical_status_update_statistics(options = {})
      path = "#{company_path(options)}/historical-status-update-statistics"
      get(path, options)
    end

    # Retrieve comments on a particular company update:
    #
    # @see http://developer.linkedin.com/reading-company-shares
    #
    # @param [String] update_key a update/update-key representing a
    #   particular company update
    # @macro company_path_options
    # @return [LinkedIn::Mash]
    def company_updates_comments(update_key, options={})
      path = "#{company_path(options)}/updates/key=#{update_key}/update-comments"
      get(path, options)
    end

    # Retrieve likes on a particular company update:
    #
    # @see http://developer.linkedin.com/reading-company-shares
    #
    # @param [String] update_key a update/update-key representing a
    #   particular company update
    # @macro company_path_options
    # @return [LinkedIn::Mash]
    def company_updates_likes(update_key, options={})
      path = "#{company_path(options)}/updates/key=#{update_key}/likes"
      get(path, options)
    end

    # Create a share for a company that the authenticated user
    # administers
    #
    # Permissions: rw_company_admin
    #
    # @see http://developer.linkedin.com/creating-company-shares
    # @see http://developer.linkedin.com/documents/targeting-company-shares Targeting Company Shares
    #
    # @param [String] company_id Company ID
    # @macro share_input_fields
    # @return [void]
    def add_company_share(company_id, share)
      path = "/companies/#{company_id}/shares"
      defaults = {visibility: {code: "anyone"}}
      post(path, MultiJson.dump(defaults.merge(share)), "Content-Type" => "application/json")
    end

    # (Create) authenticated user starts following a company
    #
    # @see http://developer.linkedin.com/documents/company-follow-and-suggestions
    #
    # @param [String] company_id Company ID
    # @return [void]
    def follow_company(company_id)
      path = "/people/~/following/companies"
      post(path, {id: company_id})
    end

    # (Destroy) authenticated user stops following a company
    #
    # @see http://developer.linkedin.com/documents/company-follow-and-suggestions
    #
    # @param [String] company_id Company ID
    # @return [void]
    def unfollow_company(company_id)
      path = "/people/~/following/companies/id=#{company_id}"
      delete(path)
    end


    private ##############################################################


    def company_path(options)
      path = "/companies"

      if domain = options.delete(:domain)
        path += "?email-domain=#{CGI.escape(domain)}"
      elsif id = options.delete(:id)
        path += "/#{id}"
      elsif url = options.delete(:url)
        path += "/url=#{CGI.escape(url)}"
      elsif name = options.delete(:name)
        path += "/universal-name=#{CGI.escape(name)}"
      elsif is_admin = options.delete(:is_admin)
        path += "?is-company-admin=#{CGI.escape(is_admin)}"
      else
        path += "/~"
      end
    end
  end
end
