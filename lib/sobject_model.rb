require 'sobject_model/rest/client'
require 'sobject_model/adapter/rest'
require 'sobject_model/adapter/sf'
require 'sobject_model/generator'

module SObjectModel
  def self.connect(api_type, options = {})
    @connection = case api_type.to_s.upcase
                  when 'REST'
                    client = Rest::Client.new(**options)
                    Adapter::Rest.new(client)
                  when 'CLI/SF'
                    Adapter::Sf.new(sf, **options)
                  end
  end

  def self.connection
    @connection
  end

  def self.generated_classes
    @generated_classes ||= []
  end

  def self.connection=(connector)
    @connection = connector
  end

  def self.generate(*sobject_types)
    generator = Generator.new(connection)
    generator.generate(*sobject_types)
  end
end
