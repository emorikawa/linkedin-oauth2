# require "spec_helper"
#
# describe LinkedIn::Companies do
#   use_vcr_cassette
#
#   it "should be able to view a company profile" do
#     stub("https://api.linkedin.com/v1/companies/id=1586?oauth2_access_token=#{client.access_token.token}")
#     expect(client.company(:id => 1586)).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to view a company by universal name" do
#     stub("https://api.linkedin.com/v1/companies/universal-name=acme?oauth2_access_token=#{client.access_token.token}")
#     expect(client.company(:name => 'acme')).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should be able to view a company by e-mail domain" do
#     stub("https://api.linkedin.com/v1/companies?email-domain=acme.com&oauth2_access_token=#{client.access_token.token}")
#     expect(client.company(:domain => 'acme.com')).to be_an_instance_of(LinkedIn::Mash)
#   end
#
#   it "should load correct company data" do
#     expect(client.company(:id => 1586).name).to == "Amazon"
#
#     data = client.company(:id => 1586, :fields => %w{ id name industry locations:(address:(city state country-code) is-headquarters) employee-count-range })
#     expect(data.id).to == 1586
#     expect(data.name).to == "Amazon"
#     expect(data.employee_count_range.name).to == "10001+"
#     expect(data.industry).to == "Internet"
#     expect(data.locations.all[0].address.city).to == "Seattle"
#     expect(data.locations.all[0].is_headquarters).to == true
#   end
#
#   it "should be able to share a new company status" do
#     stub_request(:post, "https://api.linkedin.com/v1/companies/123456/shares").to_return(:body => "", :status => 201)
#     response = client.add_company_share("123456", { :comment => "Testing, 1, 2, 3" })
#     expect(response.body).to == nil
#     expect(response.code).to == "201"
#   end
# end
