describe LinkedIn::People do

  let(:uid) {"4uXXqUsRMM"}
  let(:access_token) {"1234abc"}

  let(:api) {LinkedIn::API.new(access_token)}

  it "returns a LinkedIn::Mash" do
  end

  it "sets the first-name" do
  end

  ###### PROFILES
  # Self
  result = api.profile

  # Secure
  result = api.profile(secure: true)
  result = api.profile("secure-urls" => true)

  # Language
  result = api.profile(lang: "es")
  result = api.profile(lang: "bad_lang")

  # Others
  result = api.profile(id: uid)
  result = api.profile(url: url)
  result = api.profile(uid)
  result = api.profile(url)

  # Errors
  result = api.profile("Bad input")
  result = api.profile(email: "email@email.com")

  # Fields
  result = api.profile(fields: ["id","industry"])
  result = api.profile(fields: ["id",{"positions" => ["title"]}])

  # Multiple people
  result = api.profile(ids: ["self", uid])
  result = api.profile(ids: ["self", uid], urls: [url])
  result = api.profile(ids: ["self", uid], url: url)
  result = api.profile(ids: ["self", uid], fields: ["id", "industry"])

  ###### CONNECTIONS
  result = api.connections
  result = api.connections(id: uid)
  result = api.connections(fields: ["id", "industry"])
  result = api.connections(ids: ["self", uid])

  result = api.new_connections(since_str)
  result = api.new_connections(since_num)
  result = api.new_connections(since_time)
  result = api.new_connections(since, id: uid)
  result = api.new_connections(since, fields: ["id", "industry"])
  result = api.new_connections(since, ids: ["self", uid])

#   it "" do
#     # https://api.linkedin.com/v1/people/~
#     VCR.use_cassette("people own account") do
#       api.profile.should be_an_instance_of(LinkedIn::Mash)
#     end
#   end
#
#   it "should be able to view public profiles" do
#     # https://api.linkedin.com/v1/people/id=abcdefg
#     VCR.use_cassette("people other account") do
#       api.profile(id: "4uXXqUsRMM").should be_an_instance_of(LinkedIn::Mash)
#     end
#   end
#
#   it "should be able to view the picture urls" do
#     # stub_request(:get, "https://api.linkedin.com/v1/people/~/picture-urls::(original)").to_return(:body => "{}")
#     VCR.use_cassette("people picture url") do
#       api.picture_urls.should be_an_instance_of(LinkedIn::Mash)
#     end
#   end
#
#   it "should be able to view connections" do
#     # stub_request(:get, "https://api.linkedin.com/v1/people/~/connections").to_return(:body => "{}")
#     VCR.use_cassette("people connections") do
#       api.connections.should be_an_instance_of(LinkedIn::Mash)
#     end
#   end
#
#   it "should be able to view new connections" do
#     modified_since = Time.new(2014,1,1).to_i * 1000
#     # stub_request(:get, "https://api.linkedin.com/v1/people/~/connections?modified=new&modified-since=#{modified_since}").to_return(:body => "{}")
#     VCR.use_cassette("people new connections") do
#       api.new_connections(modified_since).should be_an_instance_of(LinkedIn::Mash)
#     end
#   end
end
