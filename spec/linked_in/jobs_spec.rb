require "spec_helper"

describe LinkedIn::Jobs do
  it "should be able to view a job listing" do
    stub_request(:get, "https://api.linkedin.com/v1/jobs/id=1586").to_return(:body => "{}")
    expect(client.job(:id => 1586)).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view its job bookmarks" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/job-bookmarks").to_return(:body => "{}")
    expect(client.job_bookmarks).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view its job suggestion" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/suggestions/job-suggestions").to_return(:body => "{}")
    expect(client.job_suggestions).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to add a bookmark" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/job-bookmarks").to_return(:body => "", :status => 201)
    response = client.add_job_bookmark(:id => 1452577)
    expect(response.body).to == nil
    expect(response.code).to == "201"
  end
end
