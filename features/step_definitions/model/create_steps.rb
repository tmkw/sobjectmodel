When('creating an account') do |example|
  @new_account = eval(example)
  data_cleaner.add :Account, @new_account.Id
end

Then('the account is created') do
  expect(@new_account).to be_instance_of Account
  expect(@new_account.Name).to eq "New Account"
  expect(@new_account.BillingCity).to eq "Sapporo"
end

Given('new account variable is created') do |example|
  @new_record = eval(example)
  expect(@new_record).to be_new_record
end

When('saving the account') do |example|
  eval(example)
  expect(@new_record).to be_persisted
  data_cleaner.add :Account, @new_account.Id
end
