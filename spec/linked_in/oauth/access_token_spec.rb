require "spec_helper"

describe "OAuth2 Access Token" do
  code = "dummy_code"
  client_id = "dummy_client_id"
  client_secret = "dummy_client_secret"
  redirect_uri = "http://lvh.me:5000"

  before(:example) do
    LinkedIn.configure do |config|
      config.client_id     = client_id
      config.client_secret = client_secret
      config.redirect_uri  = redirect_uri
    end
  end
  subject { LinkedIn::OAuth2.new }

  shared_examples "Success Access Token Fetch" do |*args|
    it "Returns an access token string" do
      expect(subject.get_access_token(*args)).to be_kind_of String
    end

    it "Sets the AcessToken object" do
      subject.get_access_token(*args)
      expect(subject.access_token).to be_kind_of OAuth2::AccessToken
    end
  end

  shared_examples "Raises InvalidRequest" do |*args|

    it "Raises an error" do
      expect{subject.get_access_token(*args)}.to raise_error(LinkedIn::InvalidRequest, msg)
    end

    it "Has no AccessToken object set" do
      expect(subject.access_token).to be_nil
    end
  end

  context "When a auth_code is provided" do
    include_examples "Success Access Token Fetch", code
  end

  context "When no code is given" do
    let(:msg) {LinkedIn::ErrorMessages.no_auth_code}
    include_examples "Raises InvalidRequest"
  end

  context "When redirect_uri is not configured and not passed in" do
    before(:example) do
      LinkedIn.configure { |config| config.redirect_uri = nil }
    end
    let(:msg) {LinkedIn::ErrorMessages.redirect_uri}
    include_examples "Raises InvalidRequest", code
  end

  context "When redirect_uri is configured and not passed in" do
    before(:example) do
      LinkedIn.configure { |config| config.redirect_uri = redirect_uri }
    end
    include_examples "Success Access Token Fetch", code
  end

  context "When redirect_uri is passed in" do
    include_examples "Success Access Token Fetch", code, {redirect_uri: redirect_uri}
  end

  context "When redirect_uri was previously set by auth_code_url" do
  end

  context "When redirect_uri does not match previous setting" do
  end

  context "When an an error is raised" do
    it "raises a response error" do
    end
  end

  context "When an an error is raised and raised_errors is false" do
    it "returns without raising an error" do
    end

    it "sets the error attribute" do
    end
  end
end
