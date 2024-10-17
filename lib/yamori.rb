require 'yamori/rest/client'
require 'yamori/adapter/rest'
require 'yamori/generator'

module Yamori
  def self.connect(api_type, options = {})
    @connection = case api_type.to_s.upcase
                  when 'REST'
                    client = Rest::Client.new(**options)
                    Adapter::Rest.new(client)
                  end
  end

  def self.connection
    @connection
  end

  def self.connection=(connector)
    @connection = connector
  end

  def self.generate(*sobject_types)
    generator = Generator.new(connection)
    generator.generate(*sobject_types)
  end
end
