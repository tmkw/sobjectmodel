require 'sobject_model'

RSpec.describe 'SObjectModel' do
  let(:api_type) { :rest }
  let(:host) { 'https://hoge.salesforce.example.com' }
  let(:token) { 'access token' }
  let(:api_ver) { 62.0 }
  let(:rest_client) { instance_double('SObjectModel::Rest::Client') }
  let(:rest_adapter) { instance_double('SObjectModel::Adapter::Rest') }

  describe '.connect and .connection' do
    it 'connect the salesforce with SObjectModel through API connection' do
      allow(SObjectModel::Rest::Client).to receive(:new).with(instance_url: host, access_token: token, api_version: api_ver).and_return(rest_client)
      allow(SObjectModel::Adapter::Rest).to receive(:new).with(rest_client).and_return(rest_adapter)

      SObjectModel.connect(api_type, instance_url: host, access_token: token, api_version: api_ver)

      expect(SObjectModel.connection).to be rest_adapter
    end
  end

  describe '.generate' do
    let(:adapter) { instance_double('SObjectModel::Adapter::Rest') }
    let(:generator) { instance_double('SObjectModel::Generator') }

    before do
      allow(SObjectModel).to receive(:connection).and_return(adapter)
      allow(SObjectModel::Generator).to receive(:new).with(adapter).and_return(generator)
      allow(generator).to receive(:generate).with(:Account, :User)
    end

    it 'generates model classes' do

      SObjectModel.generate :Account, :User

      expect(SObjectModel).to have_received(:connection)
      expect(generator).to have_received(:generate)
    end
  end
end
