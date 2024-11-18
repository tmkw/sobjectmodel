require 'sobject_model/generator'

RSpec.shared_examples 'Generator#generate' do
  let(:generator) { SObjectModel::Generator.new(connection) }

  before do
    allow(connection).to receive(:describe).with(object_name).and_return(schema)
    allow(class_definition).to receive(:to_s).and_return(class_expression)
  end

  it 'generates a class' do
    expect(generator.generate(object_name)).to include(object_name)
    expect{ Object.const_get object_name.to_sym }.not_to raise_error
    expect((Object.const_get(object_name.to_sym)).connection).to be connection

    expect(connection).to have_received :describe
    expect(class_definition).to have_received :to_s
  end

  it "doesn't generate class that aliready exists" do
    expect(generator.generate(object_name)).to be_empty
  end

    it "tracks all generated classes" do
      expect(SObjectModel.generated_classes).to include Object.const_get(object_name.to_sym)
    end
end
