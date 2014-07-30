describe "LinkedIn::AccessToken" do
  let(:tok) {:dummy_access_token}
  let(:expires_in) { 64000 }
  let(:expires_at) { Time.utc(2014,1,1) }

  context "When just token is set" do
    subject {LinkedIn::AccessToken.new(tok)}
    it("has the token value") { expect(subject.token).to eq tok }
  end

  context "When only expires_in is set" do
    subject {LinkedIn::AccessToken.new(tok, expires_in)}
    it("set expires_in") {expect(subject.expires_in).to eq expires_in}
    it("calculated expires_at") do
      calc_time = Time.now + expires_in
      diff = subject.expires_at - calc_time
      expect(diff).to be < 1
    end
  end

  context "When everything is set" do
    subject {LinkedIn::AccessToken.new(tok, expires_in, expires_at)}
    it("set token") { expect(subject.token).to eq tok }
    it("set expires_in") {expect(subject.expires_in).to eq expires_in}
    it("set expires_at") {expect(subject.expires_at).to eq expires_at}
  end
end
