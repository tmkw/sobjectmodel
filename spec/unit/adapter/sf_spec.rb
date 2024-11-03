module Yamori::Adapter
  RSpec.describe Sf do
    let(:org) { :dev }
    let(:sf) { double('sf_cli::Sf::Main') }
    let(:adapter) {Sf.new(sf, target_org: org)}
    let(:sf_org) { double('SfCli::Sf::Org::Core')  }
    let(:sf_data) { double('SfCli::Sf::Data::Core')  }

    let(:id) { anything }
    let(:object_type) { anything }
    let(:klass) { anything }
    let(:model_instance) { anything }
    let(:soql) { 'SELECT Id, Name FROM Hoge__c' }
    let(:query_result) { [anything, anything] }

    before do
      allow(sf).to receive(:org).and_return(sf_org)
      allow(sf).to receive(:data).and_return(sf_data)
    end

    describe '#find' do
      it 'execute `sf data get record`' do
        allow(sf_data).to receive(:get_record).with(object_type, record_id: id, target_org: org, model_class: klass).and_return(model_instance)

        expect(adapter.find(object_type, id, klass)).to be model_instance

        expect(sf_data).to have_received :get_record
      end
    end

    describe '#create' do
      let(:params) {{ Name: 'John Smith' }}

      before do
        allow(sf_data).to receive(:create_record).with(object_type, values: params, target_org: org).and_return(id)
      end

      it 'execute `sf data create record`' do
        expect(adapter.create(object_type, params)).to be id
        expect(sf_data).to have_received :create_record
      end

      example 'returning model object' do
        allow(adapter).to receive(:find).with(object_type, id, klass).and_return(model_instance)

        expect(adapter.create(object_type, params, klass)).to be model_instance
        expect(sf_data).to have_received :create_record
        expect(adapter).to have_received :find
      end
    end

    describe '#update' do
      let(:params) {{ Name: 'John Smith' }}

      before do
        allow(sf_data).to receive(:update_record).with(object_type, record_id: id, where: nil, values: params, target_org: org).and_return(id)
      end

      it 'execute `sf data update record`' do
        expect(adapter.update(object_type, id, params)).to be id
        expect(sf_data).to have_received :update_record
      end
    end

    describe '#delete' do
      before do
        allow(sf_data).to receive(:delete_record).with(object_type, record_id: id, where: nil, target_org: org).and_return(id)
      end

      it 'execute `sf data delete record`' do
        expect(adapter.delete(object_type, id)).to be id
        expect(sf_data).to have_received :delete_record
      end
    end

    describe '#query' do
      let(:format) { nil }

      before do
        allow(sf_data).to receive(:query).with(soql, target_org: org, model_class: klass, format: format).and_return(query_result)
      end

      it 'execute `sf data query`' do
        expect(adapter.query(soql, klass)).to be query_result
        expect(sf_data).to have_received :query
      end

      context 'when format is specified' do
        let(:format) { :csv }

        it 'execute `sf data query` with format option' do
          expect(adapter.query(soql, klass, :csv)).to be query_result
          expect(sf_data).to have_received :query
        end
      end
    end

    describe '#exec_query' do
      let(:fmt) { anything  }
      let(:bulk) { false  }
      let(:timeout) { 5  }

      before do
        allow(sf_data).to receive(:query).with(soql, target_org: org, format: fmt, bulk: bulk, wait: timeout, model_class: klass).and_return(query_result)
      end

      it 'execute `sf data query`' do
        expect(adapter.exec_query(soql, format: fmt, bulk: bulk, wait: timeout, model_class: klass)).to be query_result
        expect(sf_data).to have_received :query
      end
    end
  end
end
