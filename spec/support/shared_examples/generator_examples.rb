require 'yamori/generator'

RSpec.shared_examples 'Generator#generate' do
  let(:generator) { Yamori::Generator.new(connection) }

  before do
    allow(connection).to receive(:describe).with(object_name).and_return(schema)
    allow(class_definition).to receive(:to_s).and_return(class_expression)
  end

  it 'generates a class' do
    expect(generator.generate(object_name)).to include(object_name)
    expect(Object.const_get object_name.to_sym).to be ModelGeneratorTestClass
    expect(ModelGeneratorTestClass.connection).to be connection

    expect(connection).to have_received :describe
    expect(class_definition).to have_received :to_s
  end

  it "doesn't generate class that aliready exists" do
    expect(generator.generate(object_name)).to be_empty
  end
end
