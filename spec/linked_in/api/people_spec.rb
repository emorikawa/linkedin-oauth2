describe LinkedIn::People do
  let(:uid) {"SDmkCxL2ya"}
  let(:url) {"http://www.linkedin.com/in/evanmorikawa"}
  let(:access_token) {"dummy_access_token"}

  let(:api) {LinkedIn::API.new(access_token)}

  def verify(result)
    expect(result).to be_kind_of LinkedIn::Mash
  end

  ###### PROFILES
  # Self
  it "grabs your own profile" do
    VCR.use_cassette("people profile own") do
      result = api.profile
      verify result
      expect(result["firstName"]).to be_kind_of String
    end
  end

  # Secure
  it "accepts secure-urls param via secure option" do
    VCR.use_cassette("people profile own secure") do
      verify api.profile(secure: true)
    end
  end

  # Language
  it "gets profiles in a different language" do
    VCR.use_cassette("people profile lang spanish") do
      verify api.profile(lang: "es")
    end
  end

  # Others
  it "gets another users profile by user id" do
    VCR.use_cassette("people profile other uid") do
      result = api.profile(id: uid)
      verify result
      expect(result["firstName"]).to be_kind_of String
    end
  end
  it "gets another users profile by url" do
    VCR.use_cassette("people profile other url") do
      result = api.profile(url: url)
      verify result
      expect(result["firstName"]).to be_kind_of String
    end
  end
  it "gets another users profile by user id" do
    VCR.use_cassette("people profile other uid") do
      verify api.profile(uid)
    end
  end
  it "gets another users profile by url" do
    VCR.use_cassette("people profile other url") do
      verify api.profile(url)
    end
  end

  # Errors
  it "errors on bad input" do
    expect{api.profile("Bad input")}.to raise_error
  end
  it "errors on email deprecation" do
    msg = LinkedIn::ErrorMessages.deprecated
    expect{api.profile(email: "email@email.com")}.to raise_error(LinkedIn::Deprecated, msg)
  end

  # Fields
  it "grabs certain profile fields" do
    VCR.use_cassette("people profile fields simple") do
      result = api.profile(fields: ["id","industry"])
      verify result
      expect(result["industry"]).to be_kind_of String
    end
  end
  it "grabs more complex profile fields" do
    VCR.use_cassette("people profile fields complex") do
      result = api.profile(fields: ["id",{"positions" => ["title"]}])
      verify result
      expect(result["positions"]["values"][0]["title"]).to be_kind_of String
    end
  end

  # Multiple people
  it "grabs multiple people by uids" do
    VCR.use_cassette("people profile multiple uids") do
      result = api.profile(ids: ["self", uid])
      verify result
      expect(result["values"].length).to eq 2
    end
  end
  it "grabs multiple people by urls" do
    VCR.use_cassette("people profile multiple urls") do
      result = api.profile(urls: ["self", url])
      verify result
      expect(result["values"].length).to eq 2
    end
  end
  it "grabs multiple people by uids and urls" do
    VCR.use_cassette("people profile multiple uids and urls") do
      result = api.profile(ids: ["self", uid], urls: [url])
      verify result
      expect(result["values"].length).to eq 3
    end
  end
  it "grabs certain fields for multiple people" do
    VCR.use_cassette("people profile multiple fields") do
      result = api.profile(ids: ["self", uid], fields: ["id", "industry"])
      verify result
      expect(result["values"][0]["industry"]).to be_kind_of String
    end
  end

  ###### CONNECTIONS
  it "grabs your own connections" do
    VCR.use_cassette("people profile connections self") do
      result = api.connections
      verify result
      expect(result["values"].length).to eq 3
    end
  end
  it "grabs the connections of others" do
    VCR.use_cassette("people profile connections other") do
      result = api.connections(id: uid)
      verify result
      expect(result["values"].length).to eq 3
    end
  end
  it "grabs certain fields for those connections" do
    VCR.use_cassette("people profile connections fields") do
      result = api.connections(fields: ["id", "industry"])
      verify result
      expect(result["values"].length).to eq 4
      expect(result["values"][0]["industry"]).to be_kind_of String
    end
  end

  it "grabs new connections since a string date" do
    VCR.use_cassette("people profile new connections self") do
      result = api.new_connections("2014-01-01")
      verify result
      expect(result["values"].length).to eq 2
    end
  end
  it "grabs new connections since a numeric date" do
    VCR.use_cassette("people profile new connections self") do
      verify api.new_connections(1388534400000)
    end
  end
  it "grabs new connections since a Time.utc object" do
    VCR.use_cassette("people profile new connections self") do
      verify api.new_connections(Time.utc(2014,1,1))
    end
  end
  it "grabs new connections for another user" do
    VCR.use_cassette("people profile new connections other") do
      result = api.new_connections("2014-01-01", id: uid)
      verify result
      expect(result["values"].length).to eq 2
    end
  end
  it "grabs certain fields of new connections" do
    VCR.use_cassette("people profile new connections fields") do
      result = api.new_connections("2014-01-01", fields: ["id", "industry"])
      verify result
      expect(result["values"].length).to eq 3
      expect(result["values"][0]["industry"]).to be_kind_of String
    end
  end

  it "grabs picture urls" do
    VCR.use_cassette("people picture urls") do
      result = api.picture_urls
      verify result
      expect(result["values"][0] =~ URI::regexp).to_not be_nil
    end
  end

  it "grabs skills" do
    VCR.use_cassette("people profile skills") do
      result = api.skills
      verify result
      expect(result["all"].length).to eq 2
    end
  end  
end
