When('counting all accounts') do |example|
  @expected_count = sf.data.query("SELECT COUNT(Id) FROM Account", target_org: target_org)[0]["expr0"]
  @counts = eval(example)
end

Then('it gets the number') do
  expect(@counts).to eq @expected_count
end

When('counting accounts whose names start by ABC') do |example|
  @expected_count = sf.data.query("SELECT COUNT(Id) FROM Account WHERE Name LIKE 'ABC%'", target_org: target_org)[0]["expr0"]
  @counts = eval(example)
end

When('counting websites of all accounts') do |example|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('it gets the number of websites') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('there are some accounts who operate in Japan') do
  create :Account, Name: 'Grobal ABC01$', AnnualRevenue: 10_000_000, BillingCountry: 'Japan', BillingCity: 'Osaka'
  create :Account, Name: 'Japan DEF02%', AnnualRevenue: 20_000_000, BillingCountry: 'Japan', BillingCity: 'Osaka'
  create :Account, Name: 'Success GHI03&', AnnualRevenue: 30_000_000, BillingCountry: 'Japan', BillingCity: 'Osaka'
  create :Account, Name: 'Future JKL04#', AnnualRevenue: 40_000_000, BillingCountry: 'Japan', BillingCity: 'Nagoya'
  create :Account, Name: 'Rockstar MNO05!', AnnualRevenue: 50_000_000, BillingCountry: 'Japan', BillingCity: 'Nagoya'
end

When("counting each city's accounts in Japan") do |example|
  pending # Write code here that turns the phrase above into concrete actions
end
