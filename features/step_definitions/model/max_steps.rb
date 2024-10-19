When('finding maximum AnnualRevenue in all accounts') do |example|
  @expected_value = sf.data.query("SELECT MAX(AnnualRevenue) FROM Account", target_org: target_org)[0]["expr0"]
  @maximum_value = eval(example)
end

Then('it gets the maximum annual revenue') do
  expect(@maximum_value).to eq @expected_value
end

When('finding the maximum AnnualRevenue in Japan') do |example|
  @expected_value = sf.data.query("SELECT MAX(AnnualRevenue) FROM Account WHERE BillingCountry = 'Japan'", target_org: target_org)[0]["expr0"]
  @maximum_value = eval(example)
end

When('finding the maximum AnnualRevenue of each city in Japan') do |example|
  pending # Write code here that turns the phrase above into concrete actions
end

