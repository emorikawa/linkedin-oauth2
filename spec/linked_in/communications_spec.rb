require "spec_helper"

describe LinkedIn::Communications do
  it "should be able to send a message" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/mailbox").to_return(:body => "", :status => 201)
    response = client.send_message("subject", "body", ["recip1", "recip2"])
    expect(response.body).to == nil
    expect(response.code).to == "201"
  end
end
