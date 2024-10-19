When('API client sends a request to delete object record') do |example|
  eval(example)
end

Then('the record gets deleted') do
  expect(record_exist?(:Contact, contact_id)).to be false
end

