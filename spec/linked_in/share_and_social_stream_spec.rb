# require "spec_helper"
#
# describe LinkedIn::ShareAndSocialStream do
#   it "should be able to view network_updates" do
#     stub("https://api.linkedin.com/v1/people/~/network/updates")
#     expect(client.network_updates).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to view network_update's comments" do
#     stub("https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/update-comments")
#     expect(client.share_comments("network_update_key")).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to view network_update's likes" do
#     stub("https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/likes")
#     expect(client.share_likes("network_update_key")).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to share a new status" do
#     stub_request(:post, "https://api.linkedin.com/v1/people/~/shares").to_return(:body => "", :status => 201)
#     response = client.add_share(:comment => "Testing, 1, 2, 3")
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
#
#   it "returns the shares for a person" do
#     stub("https://api.linkedin.com/v1/people/~/network/updates?type=SHAR&scope=self&after=1234&count=35")
#     client.shares(:after => 1234, :count => 35)
#   end
#
#   it "should be able to comment on network update" do
#     stub_request(:post, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/update-comments").to_return(
#         :body => "", :status => 201)
#     response = client.update_comment('SOMEKEY', "Testing, 1, 2, 3")
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
#
#   it "should be able to like a network update" do
#     stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked").
#       with(:body => "true").to_return(:body => "", :status => 201)
#     response = client.like_share('SOMEKEY')
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
#
#   it "should be able to unlike a network update" do
#     stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked").
#       with(:body => "false").to_return(:body => "", :status => 201)
#     response = client.unlike_share('SOMEKEY')
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
# end
