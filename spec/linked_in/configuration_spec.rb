require 'spec_helper'

describe "LinkedIn configuration" do
  let(:config_value) { "Foo Bar" }

  let(:site)          { "https://www.linkedin.com"  }
  let(:token_url)     { "/uas/oauth2/accessToken"   }
  let(:authorize_url) { "/uas/oauth2/authorization" }

  subject { LinkedIn.config }

  before(:example) do
    LinkedIn.configure do |config|
      config.client_id = config_value
      config.client_secret = config_value
    end
  end

  it("has a client_id") do
    expect(subject.client_id).to eq config_value
  end

  it("has a client_secret") do
    expect(subject.client_secret).to eq config_value
  end

  it("has an aliased api_key") do
    expect(subject.api_key).to eq config_value
  end

  it("has an aliased secret_key") do
    expect(subject.secret_key).to eq config_value
  end

  it("has the correct default site") do
    expect(subject.site).to eq site
  end

  it("has the correct default token_url") do
    expect(subject.token_url).to eq token_url
  end

  it("has the correct default authorize_url") do
    expect(subject.authorize_url).to eq authorize_url
  end
end
