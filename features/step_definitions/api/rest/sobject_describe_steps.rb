When('API client sends a request to get object schema') do |example|
  @schema = eval(example)
end

Then('it gets the schema') do
  expect(@schema['name']).to eq 'Account'
end

