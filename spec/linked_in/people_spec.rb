describe LinkedIn::People do
  let(:api) {LinkedIn::API.new("123")}

  it "should be able to view the account profile" do
    # stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}")
    VCR.use_cassette("people own account") do
      api.profile.should be_an_instance_of(LinkedIn::Mash)
    end
  end

  it "should be able to view public profiles" do
    # stub_request(:get, "https://api.linkedin.com/v1/people/id=123").to_return(:body => "{}")
    VCR.use_cassette("people other account") do
      api.profile(id: "4uXXqUsRMM").should be_an_instance_of(LinkedIn::Mash)
    end
  end

  it "should be able to view the picture urls" do
    # stub_request(:get, "https://api.linkedin.com/v1/people/~/picture-urls::(original)").to_return(:body => "{}")
    VCR.use_cassette("people picture url") do
      api.picture_urls.should be_an_instance_of(LinkedIn::Mash)
    end
  end

  it "should be able to view connections" do
    # stub_request(:get, "https://api.linkedin.com/v1/people/~/connections").to_return(:body => "{}")
    VCR.use_cassette("people connections") do
      api.connections.should be_an_instance_of(LinkedIn::Mash)
    end
  end

  it "should be able to view new connections" do
    modified_since = Time.new(2014,1,1).to_i * 1000
    # stub_request(:get, "https://api.linkedin.com/v1/people/~/connections?modified=new&modified-since=#{modified_since}").to_return(:body => "{}")
    VCR.use_cassette("people new connections") do
      api.new_connections(modified_since).should be_an_instance_of(LinkedIn::Mash)
    end
  end
end
