module LinkedIn

  class Organizations < APIResource

    # Retrieves a member's organization access control information
    def organization_access(options={})
      path = "/organizationAcls?q=roleAssignee&projection=(elements*(*,organization~(localizedName)))"
      get(path, options)
    end

    # Retrieves an organization
    def organization(options={})
      path = organization_path(options)
      get(path, options)
    end

    def organization_path(options)
      path = "/organizations"

      if id = options.delete(:id)
        path += "/#{id}"
      end
    end

  end

end
