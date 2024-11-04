module SObjectModel::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#describe' do
      let(:path) { "#{base_path}/" }
      let(:http_response_body) { %|{"encoding": "UTF-8", "maxBatchSize": 200, "sobjects" : [{"name": "Account"}]}| }

      before do
        allow(http).to receive(:get).with(path).and_return(http_response_body)
      end

      it 'gets the list of sObject and some system settings' do
        result = client.describe_global
        expect(result['sobjects'][0]['name']).to eq 'Account'
        expect(result['encoding']).to eq 'UTF-8'
        expect(result['maxBatchSize']).to eq 200

        expect(http).to have_received :get
      end
    end
  end
end
