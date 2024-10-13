module ConnectionHelper
  def connection_config 
    @connection_config ||= sf.org.display target_org: ENV['SF_TARGET_ORG']
  end

  def instance_url
    connection_config.instance_url
  end
  alias host instance_url

  def access_token
    connection_config.access_token
  end
  alias token access_token

  def api_version
    connection_config.api_version
  end
  alias api_ver api_version

  def target_org
    connection_config.alias
  end
end

World(ConnectionHelper)

