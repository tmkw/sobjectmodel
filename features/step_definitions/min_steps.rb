When('finding mimimum AnnualRevenue in all accounts') do |example|
  @expected_value = sf.data.query("SELECT MIN(AnnualRevenue) FROM Account", target_org: target_org)[0]["expr0"]
  @minimum_value = eval(example)
end

Then('it gets the minimum annual revenue') do
  expect(@minimum_value).to eq @expected_value
end

When('finding the minimum AnnualRevenue in Japan') do |example|
  @expected_value = sf.data.query("SELECT MIN(AnnualRevenue) FROM Account WHERE BillingCountry = 'Japan'", target_org: target_org)[0]["expr0"]
  @minimum_value = eval(example)
end

When('finding the minimum AnnualRevenue of each city in Japan') do |example|
  pending # Write code here that turns the phrase above into concrete actions
end

