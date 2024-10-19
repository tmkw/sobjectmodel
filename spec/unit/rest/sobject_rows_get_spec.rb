module Yamori::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#find' do
      let(:id) { "accountId" }
      let(:path) { "#{base_path}/Account/#{id}" }
      let(:http_response_body) { %|{"Id" : "#{id}", "Name" : "Hoge"}| }

      before do
        allow(http).to receive(:get).with(path).and_return(http_response_body)
      end

      it 'gets a sObject record' do
        account = client.find(:Account, id)

        expect(account['Id']).to eq id
        expect(account['Name']).to eq 'Hoge'

        expect(http).to have_received :get
      end
    end
  end
end
