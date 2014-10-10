require "spec_helper"

describe LinkedIn::ShareAndSocialStream do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end

  it "should be able to view network_updates" do
    stub("https://api.linkedin.com/v1/people/~/network/updates?")
    expect(api.network_updates).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's comments" do
    stub("https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/update-comments?")
    expect(api.share_comments("network_update_key")).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's likes" do
    stub("https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/likes?")
    expect(api.share_likes("network_update_key")).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to share a new status" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.add_share(:comment => "Testing, 1, 2, 3")
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "returns the shares for a person" do
    stub("https://api.linkedin.com/v1/people/~/network/updates?type=SHAR&scope=self&after=1234&count=35&")
    api.shares(:after => 1234, :count => 35)
  end

  it "should be able to comment on network update" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/update-comments?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.update_comment('SOMEKEY', "Testing, 1, 2, 3")
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should be able to like a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked?oauth2_access_token=#{access_token}").
      with(:body => "true").to_return(body: "", status: 201)
    response = api.like_share('SOMEKEY')
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should be able to unlike a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.unlike_share('SOMEKEY')
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end
  
  context 'throttling' do
    it 'throws the right exception' do
      stub_request(:post, "https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=#{access_token}")
        .to_return(
          body: "{\n  \"errorCode\": 0,\n  \"message\": \"Throttle limit for calls to this resource is reached.\",\n  \"requestId\": \"M784AXE9MJ\",\n  \"status\": 403,\n  \"timestamp\": 1412871058321\n}",
          status: 403
        )
        
      err_msg = LinkedIn::ErrorMessages.throttled
      expect {api.add_share(:comment => "Testing, 1, 2, 3")}.to raise_error(LinkedIn::ThrottleError, err_msg)
    end
  end
end
