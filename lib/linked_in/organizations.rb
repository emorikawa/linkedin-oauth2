module LinkedIn

  class Organizations < APIResource
    # Retrieves a member's organization access control information
    def organization_access(options={})
      path = "/organizationAcls?q=roleAssignee"
      get(path, options)
    end
  end

end
