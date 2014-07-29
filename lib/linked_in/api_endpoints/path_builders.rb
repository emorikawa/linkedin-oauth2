module LinkedIn
  module APIEndpoints
    module PathBuilders

      private ############################################################

      def group_path(options)
        path = "/groups"
        if id = options.delete(:id)
          path += "/#{id}"
        end
      end


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
end
