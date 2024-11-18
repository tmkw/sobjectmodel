require 'sobject_model/class_definition'
require 'sobject_model/adapter/rest'
require_relative '../support/shared_examples/generator_examples'

RSpec.describe 'SObjectModel::Generator' do
  let(:class_definition) { instance_double('SObjectModel::ClassDefinition') }
  let(:schema)           { anything }
  let(:class_expression) { 'Class.new{def self.connection=(conn); @con = conn; end; def self.connection; @con; end}' }

  before do
    allow(SObjectModel::ClassDefinition).to receive(:new).with(schema).and_return(class_definition)
  end

  describe '#generate' do
    it_should_behave_like 'Generator#generate' do
      let(:connection) { instance_double('SObjectModel::Adapter::Rest') }
      let(:object_name)      { 'ModelGeneratorTestClass' }
    end

    context 'Sf Adapter' do
      it_should_behave_like 'Generator#generate' do
        let(:connection) { instance_double('SObjectModel::Adapter::Sf') }
        let(:object_name)      { 'ModelGeneratorTestClass2' }
      end
    end
  end
end
