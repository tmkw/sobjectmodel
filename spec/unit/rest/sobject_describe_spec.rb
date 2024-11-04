module SObjectModel::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#describe' do
      let(:path) { "#{base_path}/Account/describe" }
      let(:http_response_body) { %|{"name" : "Account"}| }

      before do
        allow(http).to receive(:get).with(path).and_return(http_response_body)
      end

      it 'gets the schema of a sObject' do
        schema = client.describe(:Account)
        expect(schema['name']).to eq 'Account'

        expect(http).to have_received :get
      end
    end
  end
end
