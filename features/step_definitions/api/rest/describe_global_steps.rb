When('API client sends a request to get all object schema') do |example|
  @describe_global = eval(example)
end

Then('it gets the list of all sobject and some system settings') do
  expect(@describe_global['encoding']).to eq "UTF-8"
  expect(@describe_global['maxBatchSize']).not_to be_zero
  expect(@describe_global['sobjects'].find{|obj| obj['name'] == 'Account'}).not_to be nil
end
