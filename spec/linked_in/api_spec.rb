require "spec_helper"

describe LinkedIn::API do
  context "With no access token" do
    let(:err_msg) { LinkedIn::ErrorMessages.no_access_token }

    it "Raises an error" do
      expect{LinkedIn::API.new}.to raise_error(LinkedIn::InvalidRequest, err_msg)
    end
  end

  context "With a string access token" do
    let(:access_token) { "dummy_access_token" }
    subject {LinkedIn::API.new(access_token)}

    it "Build a LinkedIn::API instance" do
      expect(subject).to be_kind_of LinkedIn::API
    end

    # it "Initializes an internal API client" do
    #   expect(subject.client).to be_kind_of OAuth2::Client
    # end
  end
end
