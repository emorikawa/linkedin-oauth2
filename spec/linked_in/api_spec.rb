require "spec_helper"

describe LinkedIn::API do
  context "With no access token" do
    let(:err_msg) { LinkedIn::ErrorMessages.no_access_token }

    it "Raises an error" do
      expect{LinkedIn::API.new}.to raise_error(LinkedIn::InvalidRequest, err_msg)
    end
  end

  shared_examples "test access token" do
    it "Build a LinkedIn::API instance" do
      expect(subject).to be_kind_of LinkedIn::API
    end

    it "Sets the access_token object" do
      expect(subject.access_token).to be_kind_of LinkedIn::AccessToken
    end

    it "Sets the access_token string" do
      expect(subject.access_token.token).to eq access_token
    end
  end

  context "With a string access token" do
    let(:access_token) { "dummy_access_token" }
    subject {LinkedIn::API.new(access_token)}

    include_examples "test access token"
  end

  context "With a LinkedIn::AccessToken object" do
    let(:access_token) { "dummy_access_token" }
    let(:access_token_obj) { LinkedIn::AccessToken.new(access_token) }

    subject {LinkedIn::API.new(access_token_obj)}

    include_examples "test access token"
  end
end
