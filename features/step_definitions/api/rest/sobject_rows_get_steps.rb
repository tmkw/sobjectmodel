When('API client sends a request to get object record') do |example|
  @api_response = eval(example)
end

Then('it gets the object record') do
  expect(@api_response['Id']).to eq contact_id
end

Then('it gets the object field values') do
  expect(@api_response['Name']).to eq contact_name
end

