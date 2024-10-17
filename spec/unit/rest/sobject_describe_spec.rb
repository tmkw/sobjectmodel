require 'yamori/rest/client'
module Yamori::Rest
  RSpec.describe Client do
    let(:url) { 'https://hoge.example.com' }
    let(:token) { "access token" }
    let(:api_ver) { 62.0 }
    let(:client) { Client.new(instance_url: url, access_token: token, api_version: api_ver) }
    let(:headers) { {'Authorization' => ('Bearer %{token}' % {token: token}), 'Content-Type'  => 'application/json'}  }
    let(:http) { instance_double('Yamori::Rest::Http') }
    let(:base_path){ "/services/data/v#{api_ver}/sobjects" } 
    let(:path) { base_path }

    before do
      allow(Yamori::Rest::Http).to receive(:new).with(url, token).and_return(http)
      allow(http).to receive(:get).with(path).and_return(http_response_body)
    end

    describe '#describe' do
      let(:path) { "#{base_path}/Account/describe" }
      let(:http_response_body) { %|{"name" : "Account"}| }

      it 'gets the schema of a sObject' do
        schema = client.describe(:Account)

        expect(schema['name']).to eq 'Account'
        expect(http).to have_received :get
      end
    end
  end
end
