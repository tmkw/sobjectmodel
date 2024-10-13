Given('connection to Salesforce is ready') do |example|
  eval(example)
end

When('starting generation:') do |example|
  eval(example)
end

Then('all classes get generated') do
  %i[Account Contact User].each do |klass|
    expect{ Object.const_get klass }.not_to raise_error
  end
end
