Given('connection to Salesforce is ready') do |example|
  eval(example)
end

When('starting generation:') do |example|
  eval(example)
end

When('starting generation: Account, Contact and User') do |example|
  @expected_classes = %i[Account Contact User]
  eval(example)
end

When('starting generation: Case, Opportunity and Task') do |example|
  @expected_classes = %i[Case Opportunity Task]
  eval(example)
end

Then('all classes get generated') do
  @expected_classes.each do |klass|
    expect{ Object.const_get klass }.not_to raise_error
  end
end
