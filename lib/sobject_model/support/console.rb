require 'sf_cli'
require 'sobject_model'

def use(target_org)
  config = sf.org.display target_org: target_org
  SObjectModel.connect(
    :rest,
    instance_url: config.instance_url,
    access_token: config.access_token,
    api_version:  config.api_version
  )
  unless config.connected?
    sf.org.login_web target_org: target_org, instance_url: config.instance_url
  end

  available_models.each do |model|
    Object.const_get(model).connection = conn
  end

  @current_org = config

  true
end

def available_models
  @available_models ||= []
end

def generate(*object_types)
  SObjectModel.generate(*object_types)
  available_models.append(*object_types).flatten.uniq
  object_types
end

def connection
  SObjectModel.connection
end

def target_org
  current_org.alias
end

def current_org
  @current_org
end

def query(_soql)
  soql = _soql.is_a?(SObjectModel::QueryMethods::QueryCondition) ? _soql.to_soql : _soql
  conf.inspect_mode = false
  puts sf.data.query(soql, format: :human, target_org: target_org)
  conf.inspect_mode = true
end

def orgs
  conf.inspect_mode = false
  system 'sf org list'
  conf.inspect_mode = true
end

alias :gen  :generate
alias :conn :connection

use ARGV[0] if ARGV[0]
