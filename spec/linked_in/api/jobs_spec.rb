require "spec_helper"

describe LinkedIn::Jobs, helpers: :api do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end

  it "should be able to view a job listing" do
    stub("https://api.linkedin.com/v1/jobs/id=1586?")
    expect(api.job(:id => 1586)).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view its job bookmarks" do
    stub("https://api.linkedin.com/v1/people/~/job-bookmarks?")
    expect(api.job_bookmarks).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view its job suggestion" do
    stub("https://api.linkedin.com/v1/people/~/suggestions/job-suggestions?")
    expect(api.job_suggestions).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to add a bookmark" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/job-bookmarks?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.add_job_bookmark(id: 1452577)
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end
end
