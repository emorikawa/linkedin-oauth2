module APIHelpers
  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end
end
