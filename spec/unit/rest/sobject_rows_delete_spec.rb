module SObjectModel::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#delete' do
      let(:id) { "accountId" }
      let(:path) { "#{base_path}/Account/#{id}/" }

      before do
        allow(http).to receive(:delete).with(path).and_return('204')
      end

      it 'deletes a sObject record' do
        expect(client.delete(:Account, id)).to eq id
        expect(http).to have_received :delete
      end
    end
  end
end
