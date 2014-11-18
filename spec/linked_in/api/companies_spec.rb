require "spec_helper"

describe LinkedIn::Companies do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end

  it "should be able to view a company profile" do
    stub("https://api.linkedin.com/v1/companies/1586?")
    expect(api.company(id: 1586)).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view a company by universal name" do
    stub("https://api.linkedin.com/v1/companies/universal-name=acme?")
    expect(api.company(name: "acme")).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view a company by e-mail domain" do
    stub("https://api.linkedin.com/v1/companies?email-domain=acme.com&")
    expect(api.company(domain: "acme.com")).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should load correct company data" do
    VCR.use_cassette("companies data") do
      data = api.company(id: 1586, fields: %w{ id name industry locations:(address:(city state country-code) is-headquarters) employee-count-range })
      expect(data.id).to eq 1586
      expect(data.name).to eq "Amazon"
      expect(data.industry).to eq "Internet"
      expect(data.employee_count_range.name).to eq "10001+"
      expect(data.locations.all[0].address.city).to eq "Seattle"
      expect(data.locations.all[0].is_headquarters).to eq true
    end
  end

  it "should be able to share a new company status" do
    stub_request(:post, "https://api.linkedin.com/v1/companies/123456/shares?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.add_company_share("123456", { comment: "Testing, 1, 2, 3" })
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should be able to follow a company" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/following/companies?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.follow_company(1586)
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should be able to unfollow a company" do
    stub_request(:delete, "https://api.linkedin.com/v1/people/~/following/companies/id=1586?oauth2_access_token=#{access_token}").to_return(body: "", status: 201)
    response = api.unfollow_company(1586)
    expect(response.body).to eq ""
    expect(response.status).to eq 201
  end

  it "should load historical follow statistics" do
    stub("https://api.linkedin.com/v1/companies/123456/historical-follow-statistics?start-timestamp=1378252800000&time-granularity=day&")
    expect(
      api.company_historical_follow_statistics(:id => 123456, :"start-timestamp" => 1378252800000, :"time-granularity" => "day")
    ).to be_an_instance_of(LinkedIn::Mash)
  end

  it "should load historical status update statistics" do
    url = "https://api.linkedin.com/v1/companies/123456/historical-status-update-statistics:(time,like-count,share-count)?oauth2_access_token=#{access_token}&start-timestamp=1378252800000&time-granularity=month"
    stub_request(:get, url).to_return(body: '{}')
    expect(
      api.company_historical_status_update_statistics(:id => 123456, :"start-timestamp" => 1378252800000, :"time-granularity" => "month", :fields => ['time', 'like-count', 'share-count'])
    ).to be_an_instance_of(LinkedIn::Mash)
  end
end
