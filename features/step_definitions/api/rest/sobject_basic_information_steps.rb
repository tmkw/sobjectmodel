When('API client sends a request to create object record') do |example|
  @new_contact_id = eval(example)
  data_cleaner.add(:Contact, @new_contact_id)
end

Then('the record gets created') do
  expect(record_exist? :Contact, Name: 'New Contact Name').to be true 
end
