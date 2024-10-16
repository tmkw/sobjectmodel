When('taking an account') do |example|
  @an_account = eval(example)
end

Then('it gets one of accounts') do
  expect(@an_account).to be_instance_of Account
  expect(@an_account.Id).not_to be nil
end

Given('there are some accounts whose name starts with ABC') do
  create :Account, Name: "ABC 0001"
  create :Account, Name: "ABC 0002"
  create :Account, Name: "ABC 0003"
end

Then('it gets one of them') do
  expect(@an_account.Name).to match /\AABC 000[1-3]\Z/
end
