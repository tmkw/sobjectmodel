require 'yamori/connection/rest'
require 'yamori/generator'

module Yamori
  def self.connect(api_type, options = {})
    @connection = case api_type.to_s.upcase
                  when 'REST'
                    Connection::Rest.new(**options)
                  end
  end

  def self.connection
    @connection
  end

  def self.generate(*sobject_types)
    generator = Generator.new(connection)
    generator.generate(*sobject_types)
  end
end
