require 'yamori'
require 'sf_cli'
require 'byebug'

def reset_session
  config = sf.org.display target_org: ENV['SF_TARGET_ORG']
  return if config.connected?

  sf.org.login_web target_org: config.alias, instance_url: config.instance_url
end


reset_session
