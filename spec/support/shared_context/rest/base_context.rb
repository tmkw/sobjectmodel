RSpec.shared_context 'rest client base context' do
  let(:url) { 'https://hoge.example.com' }
  let(:token) { "access token" }
  let(:api_ver) { 62.0 }
  let(:client) { SObjectModel::Rest::Client.new(instance_url: url, access_token: token, api_version: api_ver) }
  let(:headers) { {'Authorization' => ('Bearer %{token}' % {token: token}), 'Content-Type'  => 'application/json'}  }
  let(:http) { instance_double('SObjectModel::Rest::Http') }
  let(:base_path){ "/services/data/v#{api_ver}/sobjects" } 
  let(:path) { base_path }

  before do
    allow(SObjectModel::Rest::Http).to receive(:new).with(url, token).and_return(http)
  end
end
