require "spec_helper"

describe LinkedIn::API do
  context "With no access token" do
    let(:err_msg) { LinkedIn::ErrorMessages.no_access_token }

    it "Raises an error" do
      expect{LinkedIn::API.new}.to raise_error(LinkedIn::InvalidRequest, err_msg)
    end
  end

  let(:access_token) { "dummy_access_token" }
end
