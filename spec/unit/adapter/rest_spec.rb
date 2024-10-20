RSpec.describe 'Yamori::Adapter::Rest' do
  let(:client) { instance_double('Yamori::Rest::Client') }
  let(:adapter) {Yamori::Adapter::Rest.new(client)}

  let(:id) { anything }
  let(:object_type) { anything }
  let(:klass) { double('Model Class') }
  let(:model_instance) { anything }
  let(:soql) { 'SELECT Id, Name FROM Hoge__c' }
  let(:query_result) { instance_double('Yamori::Rest::QueryResult') }
  let(:raw_records) { [{Name: 'hoge'}, {Name: 'bar'}] }
  let(:records) { [model_instance, model_instance] }

  describe '#find' do
    let(:attributes) { {Id: 'xxxx', Name: 'name'} }

    before do
      allow(client).to receive(:find).with(object_type, id).and_return(attributes)
      allow(klass).to receive(:new).with(attributes).and_return(model_instance)
    end

    it 'gets a record' do
      expect(adapter.find(object_type, id, klass)).to be model_instance
      expect(client).to have_received :find
      expect(klass).to have_received :new
    end
  end

  describe '#create' do
    let(:params) {{ Name: 'John Smith' }}

    before do
      allow(client).to receive(:create).with(object_type, params).and_return(id)
    end

    it 'creates a record and returns id' do
      expect(adapter.create(object_type, params)).to be id
      expect(client).to have_received :create
    end

    example 'returning model object' do
      allow(adapter).to receive(:find).with(object_type, id, klass).and_return(model_instance)

      expect(adapter.create(object_type, params, klass)).to be model_instance
      expect(client).to have_received :create
      expect(adapter).to have_received :find
    end
  end

  describe '#update' do
    let(:params) {{ Name: 'John Smith' }}

    before do
      allow(client).to receive(:update).with(object_type, id, params).and_return(id)
    end

    it 'updates a record and returns id' do
      expect(adapter.update(object_type, id, params)).to be id
      expect(client).to have_received :update
    end
  end

  describe '#delete' do
    before do
      allow(client).to receive(:delete).with(object_type, id).and_return(id)
    end

    it 'deletes a record and returns id' do
      expect(adapter.delete(object_type, id)).to be id
      expect(client).to have_received :delete
    end
  end

  describe '#query' do
    before do
      allow(adapter).to receive(:exec_query).with(soql, model_class: klass).and_return(records)
    end

    it 'queries by SOQL and gets the result' do
      expect(adapter.query(soql, klass)).to be records
      expect(adapter).to have_received :exec_query
    end
  end

  describe '#exec_query' do
    before do
      allow(client).to receive(:query).with(soql).and_return(query_result)
    end

    it 'queries by SOQL and gets the result' do
      allow(query_result).to receive(:to_records).and_return(raw_records)

      expect(adapter.exec_query(soql)).to be raw_records

      expect(client).to have_received :query
      expect(query_result).to have_received :to_records
    end

    example 'returns model instances' do
      allow(query_result).to receive(:to_records).with(model_class: klass).and_return(records)

      expect(adapter.exec_query(soql, model_class: klass)).to be records

      expect(client).to have_received :query
      expect(query_result).to have_received :to_records
    end
  end
end
