require 'spec_helper'

describe LinkedIn do
  it "is a module" do
    expect(LinkedIn).to be_a Module
  end

  it "is independently loadable" do
    expect { require 'linkedin-oauth2' }.not_to raise_error
  end
end
