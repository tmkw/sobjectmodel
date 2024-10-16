require 'yamori/class_definition'
require 'yamori/connection/rest'
require_relative '../support/shared_examples/generator_examples'

RSpec.describe 'Yamori::Generator' do
  let(:class_definition) { instance_double('Yamori::ClassDefinition') }
  let(:schema)           { anything }
  let(:class_expression) { 'Class.new{def self.connection=(conn); @con = conn; end; def self.connection; @con; end}' }
  let(:object_name)      { 'ModelGeneratorTestClass' }

  before do
    allow(Yamori::ClassDefinition).to receive(:new).with(schema).and_return(class_definition)
  end

  describe '#generate' do
    it_should_behave_like 'Generator#generate' do
      let(:connection) { instance_double('Yamori::Connection::Rest') }
    end
  end
end
