describe "LinkedIn configuration" do
  let(:config_value) { "Foo Bar" }
  subject { LinkedIn.config }

  before(:example) do
    LinkedIn.foo
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
end
