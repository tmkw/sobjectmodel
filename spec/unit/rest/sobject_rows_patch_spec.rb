module SObjectModel::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#update' do
      let(:id) { "accountId" }
      let(:values) { {Name: 'updated name'} }
      let(:path) { "#{base_path}/Account/#{id}/" }

      before do
        allow(http).to receive(:patch).with(path, values).and_return('204')
      end

      it 'updates a sObject record' do
        expect(client.update(:Account, id, values)).to eq id
        expect(http).to have_received :patch
      end
    end
  end
end
