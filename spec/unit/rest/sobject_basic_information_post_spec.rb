module Yamori::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#create' do
      let(:id) { "001D000000IqhSLIAZ" }
      let(:values) { {Name: 'updated name'} }
      let(:path) { "#{base_path}/Account/" }
      let(:http_response_body) { %|{"id" : "#{id}", "errors" : [ ], "success" : true}| }

      before do
        allow(http).to receive(:post).with(path, values).and_return(http_response_body)
      end

      it 'creates a sObject record' do
        expect(client.create(:Account, values)).to eq id
        expect(http).to have_received :post
      end
    end
  end
end
