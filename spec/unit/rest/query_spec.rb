module Yamori::Rest
  RSpec.describe Client, :rest_request, type: :unit do
    describe '#query' do
      let(:path) { "/services/data/v#{api_ver}/query?q=SELECT+Id%2C+Name+FROM+Contact" } # exactly saying, this is path + query
      let(:http_response_body) { query_response }

      before do
        allow(http).to receive(:get).with(path).and_return(http_response_body)
      end

      it 'gets records' do
        query_result = client.query "SELECT Id, Name FROM Contact"
        expect(query_result).to be_completed

        records = query_result.to_records
        expect(records.count).to eq 1
        expect(records[0]['Name']).to eq 'John Smith'

        expect(http).to have_received :get
      end
    end

    def query_response
      <<~JSON
        {
          "totalSize": 1,
          "done": true,
          "records": [
            {
              "attributes": {
                "type": "Contact",
                "url": "/services/data/v60.0/sobjects/Contact/003RO0000035WQgYAM"
              },
              "Id": "003RO0000035WQgYAM",
              "Name": "John Smith"
            }
          ]
        }
      JSON
    end
  end
end
