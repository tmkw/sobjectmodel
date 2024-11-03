Given('get a record') do |example|
  @an_account = eval(example)
  expect(@an_account.BillingCity).to eq 'Tokyo'
end

Given('gets an account') do |example|
  @an_account = eval(example)
  expect(@an_account.BillingCity).to eq 'Tokyo'
end

Given("change the account's billing city to Kanazawa") do
  @an_account.BillingCity = 'Kanazawa'
end

Given("sets empty the account's billing city") do |example|
  @an_account.BillingCity = nil
end

When('updating the account') do |example|
  eval(example)
  expect(@an_account).to be_persisted
end

Then('the account is updated') do
  updated = Account.find account_id
  expect(updated.BillingCity).to eq 'Kanazawa'
end

Then('the account get updated') do
  updated = Account.find account_id
  expect(updated).not_to be nil
end

Then("the account's billing city is empty") do
  updated = Account.find account_id
  expect(updated.BillingCity).to be nil
end
