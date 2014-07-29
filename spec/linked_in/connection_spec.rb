describe LinkedIn::Connection do
  it "inherits from Faraday::Connection" do
    expect(subject).to be_kind_of Faraday::Connection
  end

  it "has the correct default url" do
    url = LinkedIn.config.api + LinkedIn.config.api_version
    expect(subject.url_prefix.to_s).to eq url
  end
end
