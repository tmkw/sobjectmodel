require 'yamori'

RSpec.describe 'Yamori' do
  let(:api_type) { :rest }
  let(:host) { 'https://hoge.salesforce.example.com' }
  let(:token) { 'access token' }
  let(:api_ver) { 62.0 }
  let(:rest_client) { instance_double('Yamori::Rest::Client') }
  let(:rest_adapter) { instance_double('Yamori::Adapter::Rest') }

  describe '.connect and .connection' do
    it 'connect the salesforce with Yamori through API connection' do
      allow(Yamori::Rest::Client).to receive(:new).with(instance_url: host, access_token: token, api_version: api_ver).and_return(rest_client)
      allow(Yamori::Adapter::Rest).to receive(:new).with(rest_client).and_return(rest_adapter)

      Yamori.connect(api_type, instance_url: host, access_token: token, api_version: api_ver)

      expect(Yamori.connection).to be rest_adapter
    end
  end

  describe '.generate' do
    let(:adapter) { instance_double('Yamori::Adapter::Rest') }
    let(:generator) { instance_double('Yamori::Generator') }

    before do
      allow(Yamori).to receive(:connection).and_return(adapter)
      allow(Yamori::Generator).to receive(:new).with(adapter).and_return(generator)
      allow(generator).to receive(:generate).with(:Account, :User)
    end

    it 'generates model classes' do

      Yamori.generate :Account, :User

      expect(Yamori).to have_received(:connection)
      expect(generator).to have_received(:generate)
    end
  end
end
