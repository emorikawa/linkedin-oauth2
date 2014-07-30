module LinkedIn
  # Jobs API
  #
  # @see http://developer.linkedin.com/documents/job-lookup-api-and-fields Job Lookup API and Fields
  # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions Job Bookmarks and Suggestions
  #
  # The following API actions do not have corresponding methods in
  # this module
  #
  #   * DELETE a Job Bookmark
  class Jobs < APIResource
    # Retrieve likes on a particular company update:
    #
    # @see http://developer.linkedin.com/reading-company-shares
    #
    # @param [Hash] options identifies the job
    # @option options [String] id unique identifier for a job
    # @return [LinkedIn::Mash]
    def job(options = {})
      path = jobs_path(options)
      get(path, options)
    end

    # Retrieve the current members' job bookmarks
    #
    # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
    #
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def job_bookmarks(options = {})
      path = "#{profile_path(options)}/job-bookmarks"
      get(path, options)
    end

    # Retrieve job suggestions for the current user
    #
    # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
    #
    # @macro profile_options
    # @return [LinkedIn::Mash]
    def job_suggestions(options = {})
      path = "#{profile_path(options)}/suggestions/job-suggestions"
      get(path, options)
    end

    # Create a job bookmark for the authenticated user
    #
    # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
    #
    # @param [String] job_id Job ID
    # @return [void]
    def add_job_bookmark(job_id)
      path = "/people/~/job-bookmarks"
      post(path, {job: {id: job_id}})
    end

    private ##############################################################

    def jobs_path(options)
      path = "/jobs"
      if id = options.delete(:id)
        path += "/id=#{id}"
      else
        path += "/~"
      end
    end
  end
end
