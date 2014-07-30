require "spec_helper"

describe LinkedIn::Communications do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  it "should be able to send a message" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/mailbox?oauth2_access_token=dummy_access_token").to_return(body: "", status: 201)
    response = api.send_message("subject", "body", ["recip1", "recip2"])
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end
end
