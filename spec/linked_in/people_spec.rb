describe LinkedIn::APIEndpoints::People do
  let(:api) {LinkedIn::API.new("stub_access_token")}

  it "should be able to view the account profile" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}")
    api.profile.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view public profiles" do
    stub_request(:get, "https://api.linkedin.com/v1/people/id=123").to_return(:body => "{}")
    api.profile(:id => 123).should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view the picture urls" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/picture-urls::(original)").to_return(:body => "{}")
    api.picture_urls.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view connections" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/connections").to_return(:body => "{}")
    api.connections.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view new connections" do
    modified_since = Time.now.to_i * 1000
    stub_request(:get, "https://api.linkedin.com/v1/people/~/connections?modified=new&modified-since=#{modified_since}").to_return(:body => "{}")
    api.new_connections(modified_since).should be_an_instance_of(LinkedIn::Mash)
  end
end
