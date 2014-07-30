# require "spec_helper"
#
# describe LinkedIn::Groups do
#   it "should be able to list group memberships for a profile" do
#     stub("https://api.linkedin.com/v1/people/~/group-memberships")
#     expect(client.group_memberships).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to list suggested groups for a profile" do
#     stub("https://api.linkedin.com/v1/people/~/suggestions/groups")
#     response = client.group_suggestions
#     expect(response.id).to == '123'
#   end
#
#   it "should be able to parse nested fields" do
#     stub("https://api.linkedin.com/v1/people/~/group-memberships:(group:(id,name,small-logo-url,short-description))")
#     expect(client.group_memberships(:fields => [{:group => ['id', 'name', 'small-logo-url', 'short-description']}])).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to join a group" do
#     stub_request(:put, "https://api.linkedin.com/v1/people/~/group-memberships/123").to_return(:body => "", :status => 201)
#
#     response = client.join_group(123)
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
#
#   it "should be able to list a group profile" do
#     stub("https://api.linkedin.com/v1/groups/123")
#     response = client.group_profile(:id => 123)
#     expect(response.id).to == '123'
#   end
#
#   it "should be able to list group posts" do
#     stub("https://api.linkedin.com/v1/groups/123/posts")
#     response = client.group_posts(:id => 123)
#     expect(response.id).to == '123'
#   end
#
#   it 'should be able to post a discussion to a group' do
#     expected = {
#       'title' => 'New Discussion',
#       'summary' => 'New Summary',
#       'content' => {
#         "submitted-url" => "http://www.google.com"
#       }
#     }
#
#     stub_request(:post, "https://api.linkedin.com/v1/groups/123/posts").with(:body => expected).to_return(:body => "", :status => 201)
#     response = client.post_group_discussion(123, expected)
#     expect(response.body).to == nil
#     expect(response.code).to == '201'
#   end
#
#   it "should be able to share a new group status" do
#     stub_request(:post, "https://api.linkedin.com/v1/groups/1/posts").to_return(:body => "", :status => 201)
#     response = client.add_group_share(1, :comment => "Testing, 1, 2, 3")
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
# end
