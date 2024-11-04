require 'sobject_model'
require 'sf_cli'
require 'byebug'

def reset_session
  raise 'SF_TARGET_ORG environment variable must be set with your target org' unless ENV['SF_TARGET_ORG']

  config = sf.org.display target_org: ENV['SF_TARGET_ORG']
  return if config.connected?

  sf.org.login_web target_org: config.alias, instance_url: config.instance_url
end


reset_session
