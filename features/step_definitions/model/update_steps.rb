Given('get a record') do |example|
  @an_account = eval(example)
  expect(@an_account.BillingCity).to eq 'Tokyo'
end

Given("change the account's billing city to Kanazawa") do
  @an_account.BillingCity = 'Kanazawa'
end

When('updating the account') do |example|
  eval(example)
  expect(@an_account).to be_persisted
end

Then('the account is updated') do
  updated = Account.find account_id
  expect(updated.BillingCity).to eq 'Kanazawa'
end
