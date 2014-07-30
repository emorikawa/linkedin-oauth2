require "spec_helper"

describe LinkedIn::Search, helpers: :api do
  let(:access_token) {"dummy_access_token"}
  let(:api) {LinkedIn::API.new(access_token)}

  def stub(url)
    url += "oauth2_access_token=#{access_token}"
    stub_request(:get, url).to_return(body: '{}')
  end

  it "lets you search for all your contacts" do
    stub("https://api.linkedin.com/v1/people-search?")
    expect(api.search()).to be_kind_of LinkedIn::Mash
  end

  it "allows a keyword search with no hash" do
    stub("https://api.linkedin.com/v1/people-search?keywords=Proximate%20Harvard&")
    expect(api.search("Proximate Harvard")).to be_kind_of LinkedIn::Mash
  end

  it "allows a keyword search with the kewywords option" do
    stub("https://api.linkedin.com/v1/people-search?keywords=Proximate%20Harvard&")
    expect(api.search(keywords: "Proximate Harvard")).to be_kind_of LinkedIn::Mash
  end

  it "lets you search by an attribute" do
    stub("https://api.linkedin.com/v1/people-search?school-name=Olin%20College%20of%20Engineering&")
    expect(api.search(school_name: "Olin College of Engineering")).to be_kind_of LinkedIn::Mash
  end

  it "combines searches" do
    stub("https://api.linkedin.com/v1/people-search?first-name=Evan&last-name=Morikawa&")
    expect(api.search(first_name: "Evan", last_name: "Morikawa")).to be_kind_of LinkedIn::Mash
  end

  it "searches for specific fields" do
    stub("https://api.linkedin.com/v1/people-search:(people:(id,first-name,last-name),num-results)?")
    expect(api.search(fields: [{people: ["id", "first-name", "last-name"]}, "num-results"])).to be_kind_of LinkedIn::Mash
  end

  it "allows you to pass a sort parameter" do
    stub("https://api.linkedin.com/v1/people-search?sort=connections&")
    expect(api.search(sort: "connections")).to be_kind_of LinkedIn::Mash
  end

  it "it allows start and count parameters" do
    stub("https://api.linkedin.com/v1/people-search?start=10&count=5&")
    expect(api.search(start: 10, count: 5)).to be_kind_of LinkedIn::Mash
  end

  it "it lets you search by facets" do
    stub("https://api.linkedin.com/v1/people-search:(facets:(code,buckets:(code,name)))?facets=location&")

    fields = {facets: ["code", {buckets: ["code", "name"]}]}

    expect(api.search(fields: fields,
                      facets: "location")).to be_kind_of LinkedIn::Mash
  end

  it "lets you search for complex facets" do
    stub("https://api.linkedin.com/v1/people-search:(facets:(code,buckets:(code,name,count)))?facets=location,network&facet=location,us:84&facet=network,F&")

    fields = {facets: ["code", {buckets: ["code", "name", "count"]}]}

    expect(api.search(fields: fields,
                      facets: "location,network",
                      facet: ["location,us:84", "network,F"])
          ).to be_kind_of LinkedIn::Mash
  end
end
