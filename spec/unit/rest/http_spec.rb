module Yamori::Rest
  RSpec.describe Http do
    let(:http) { Http.new('https://hoge.example.com', 'access token') }
    let(:path) { '/path/to/resource/' }
    let(:data) { {Name: 'hoge', Age: 36} }
    let(:response) { instance_double('Net::HTTPResponse') }

    describe '#post' do
      let(:records) { %|{"id" : "AAAAAAAAA", "errors" : [], "success" : true}| }

      before do
        allow(http).to receive(:post_request).with(path, data).and_return(response)
        allow(response).to receive(:body).and_return(records)
      end

      it 'send a POST request' do
        expect(http.post path, data).to eq records
        expect(http).to have_received :post_request
      end
    end

    describe '#patch' do
      let(:path) { '/path/to/resource/' }

      before do
        allow(http).to receive(:post_request).with(path + '?_HttpMethod=PATCH', data).and_return(response)
        allow(response).to receive(:code).and_return('204')
      end

      it 'send a (pseudo) PATCH request' do
        expect(http.patch path, data).to eq '204'
        expect(http).to have_received :post_request
      end
    end

    describe '#delete' do
      let(:path) { '/path/to/resource/' }

      before do
        allow(http).to receive(:post_request).with(path + '?_HttpMethod=DELETE', '').and_return(response)
        allow(response).to receive(:code).and_return('204')
      end

      it 'send a (pseudo) DELETE request' do
        expect(http.delete path).to eq '204'
        expect(http).to have_received :post_request
      end
    end
  end
end
