Given('○') do
  expect(account_id).not_to be nil
end

When('finding an account') do |example|
  @an_account = eval(example)
end

Then('it gets the account') do
  expect(@an_account).to be_instance_of Account
  expect(@an_account.Id).to eq account.Id
  expect(@an_account.Name).to eq account.Name
end

Given('X') do
  sf.data.delete_record :Account, record_id: account_id, target_org: target_org
end

Then('it gets nil') do
  expect(@an_account).to be nil
end
