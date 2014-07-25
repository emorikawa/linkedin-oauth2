require 'spec_helper'

describe LinkedIn::OAuth2 do
  let(:oauth_host)     { "https://www.linkedin.com"  }
  let(:token_path)     { "/uas/oauth2/accessToken"   }
  let(:authorize_path) { "/uas/oauth2/authorization" }

  let(:client_id)     { "dummy_client_id" }
  let(:client_secret) { "dummy_client_secret" }

  it "creates a valid oauth object" do
    expect(subject).to be_kind_of(LinkedIn::OAuth2)
  end

  it "is a subclass of OAuth2::Client" do
    expect(subject).to be_kind_of(OAuth2::Client)
  end

  shared_examples "verify client" do
    it "assigned the client_id to id" do
      expect(subject.id).to eq client_id
    end
    it "assigned the client_secret to secret" do
      expect(subject.secret).to eq client_secret
    end
    it "assigned the site to oauth_host" do
      expect(subject.site).to eq oauth_host
    end
    it "assigned the authorize_url option" do
      expect(subject.options[:authorize_url]).to eq authorize_path
    end
    it "assigned the token_url option" do
      expect(subject.options[:token_url]).to eq token_path
    end
  end

  context "When client credentials exist" do
    before(:example) do
      LinkedIn.configure do |config|
        config.client_id     = client_id
        config.client_secret = client_secret
      end
    end

    include_examples "verify client"
  end

  context "When client credentials do not exist" do
    let(:err_msg) {"Client credentials do not exist. Please either pass your client_id and client_secret to the LinkedIn::Oauth.new constructor or set them via LinkedIn.configure"}

    it "raises an error" do
      expect { LinkedIn::OAuth2.new }.to raise_error(LinkedIn::Errors::GeneralError, err_msg)
    end
  end

  context "When client credentials are passed in" do
    subject { LinkedIn::OAuth2.new(client_id, client_secret) }

    include_examples "verify client"
  end

  shared_examples "options take" do
    it "overrides default options" do
      expect(subject.options[:raise_errors]).to eq false
    end
    it "sets new options" do
      expect(subject.options[:new_opt]).to eq "custom option"
    end
  end

  let(:options) do
    return {raise_errors: false,
            new_opt: "custom option"}
  end

  context "When custom options are passed in" do
    subject do
      LinkedIn::OAuth2.new(client_id, client_secret, options)
    end
    include_examples "options take"
  end

  context "When custom options are passed in as first arg" do
    subject do
      LinkedIn::OAuth2.new(options)
    end
    include_examples "options take"
  end
end
