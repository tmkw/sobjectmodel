require 'yamori/rest/http'

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
    end
  end
end
