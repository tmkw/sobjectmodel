def rest_client
  @rest_client ||= SObjectModel::Rest::Client.new(instance_url: host, access_token: token, api_version: api_ver)
end
