Given('there are {int} contacts whose names start with XYZ') do |int|
  int.times do |n|
    create :Contact, LastName: "XYZ 00#{int}"
  end
end

When('API client sends a request to get records by SOQL') do |example|
  @query_result = eval(example)
end

Then('it gets the records') do
  expect(@query_result).to be_completed

  records = @query_result.to_records

  expect(records.count).to eq 3
  expect(records[0]['Name']).to start_with 'XYZ 00' 
  expect(records[1]['Name']).to start_with 'XYZ 00' 
  expect(records[2]['Name']).to start_with 'XYZ 00' 
end
