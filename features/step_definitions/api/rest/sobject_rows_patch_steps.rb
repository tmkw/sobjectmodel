When('API client sends a request to update object record') do |example|
  eval(example)
end

Then('the record gets updated') do
  reload_contact
  expect(contact_name).to eq 'Name Updated'
end

