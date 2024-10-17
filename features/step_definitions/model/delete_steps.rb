When('delete the account') do |example|
  eval(example)
end

Then('the account is deleted') do
  expect(Account.find account_id).to be nil
end
