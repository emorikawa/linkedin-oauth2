require "spec_helper"

describe LinkedIn::Groups do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end

  it "should be able to list group memberships for a profile" do
    stub("https://api.linkedin.com/v1/people/~/group-memberships?")
    expect(api.group_memberships).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to list suggested groups for a profile" do
    stub("https://api.linkedin.com/v1/people/~/suggestions/groups?")
    expect(api.group_suggestions).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to parse nested fields" do
    stub("https://api.linkedin.com/v1/people/~/group-memberships:(group:(id,name,small-logo-url,short-description))?")
    expect(api.group_memberships(fields: [{group: ["id",
                                                   "name",
                                                   "small-logo-url",
                                                   "short-description"]}])
          ).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to join a group" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/group-memberships/123?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)

    response = api.join_group(123)
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should be able to list a group profile" do
    stub("https://api.linkedin.com/v1/groups/123?")
    expect(api.group_profile(:id => 123)).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to list group posts" do
    stub("https://api.linkedin.com/v1/groups/123/posts?")
    expect(api.group_posts(:id => 123)).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to share a new group status" do
    stub_request(:post, "https://api.linkedin.com/v1/groups/1/posts?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.add_group_share(1, comment: "Testing, 1, 2, 3")
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end
end
