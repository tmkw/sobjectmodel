require 'json'

module Yamori::Rest
  RSpec.describe Http, :webmock do
    let(:instance_url) { 'https://example.com' }
    let(:access_token) { 'access token' }
    let(:http) { described_class.new(instance_url, access_token) }
    let(:headers) { {'Authorization' => ('Bearer %{token}' % {token: access_token}), 'Content-Type'  => 'application/json'} }

    describe '#get' do
      let(:path) { '/foo/baz/bar' }
      let(:response) { %|{ "hoge": "aaaaaa"}| }

      before do
        stub_request(:get, instance_url + path).with(headers: headers).to_return(body: response)
      end

      it 'send a GET request' do
        expect(http.get(path)).to eq(response)
        expect(WebMock).to have_requested(:get, instance_url + path).with(headers: headers) 
      end

      context 'when there was no resource(record)' do
        let(:response) { %|[{"message" : "The requested resource does not exist", "errorCode" : "NOT_FOUND" }]| }

        it 'raise an error to notify that there is no record' do
          expect{ http.get(path) }.to raise_error(RecordNotFoundError)
        end
      end

      context 'when there were some errors except not-found' do
        let(:response) { %|[{"fields" : [ "Id" ], "message" : "Account ID: id value of incorrect type: 001900K0001pPuOAAU", "errorCode" : "MALFORMED_ID"}]| }

        it 'raises an error' do
          expect{ http.get(path) }.to raise_error(RequestError)
        end
      end
    end

    describe '#post_request' do
      let(:path) { '/foo/baz/bar/' }
      let(:body) { {Name: 'name created'} }
      let(:response_body) { %|{"id":"id","errors":[],"success":true}| }

      it 'sends a POST request' do
        stub_request(:post, instance_url + path)
          .with(body: JSON.dump(body), headers: headers)
          .to_return(body: response_body, headers: {'Content-Length' => response_body.size})

        response = http.__send__ :post_request, path, body
        expect(response).to be_a Net::HTTPResponse # maybe http response code is between 200 and 204
        expect(response.body).to eq response_body

        expect(WebMock).to have_requested(:post, instance_url + path).with(body: JSON.dump(body), headers: headers)
      end

      context 'when there were some request errors' do
        let(:response_body) { %|something is wrong| }
        before do
          stub_request(:post, instance_url + path)
            .with(body: JSON.dump(body), headers: headers)
            .to_return(body: response_body, headers: {'Content-Length' => response_body.size}, status: 401)
        end

        it 'raises an error' do
          expect{ http.__send__ :post_request, path, body }.to raise_error(RequestError)
        end
      end

      context 'when there were some request errors' do
        let(:response_body) { %|something is wrong| }
        before do
          stub_request(:post, instance_url + path)
            .with(body: JSON.dump(body), headers: headers)
            .to_return(body: response_body, headers: {'Content-Length' => response_body.size}, status: 500)
        end

        it 'raises an error' do
          expect{ http.__send__ :post_request, path, body }.to raise_error(RequestError)
        end
      end
    end
  end
end
