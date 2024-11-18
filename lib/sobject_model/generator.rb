require_relative '../sobject_model'
require_relative './class_definition'

module SObjectModel
  class Generator
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    def connected?
      connection.nil? == false
    end

    def generate(*object_types)
      generated_types = []
      object_types.each do |object_type|
        next if generated? object_type

        schema = describe(object_type)
        class_definition = ClassDefinition.new(schema)

        instance_eval "::#{object_type} = #{class_definition}"
        klass = Object.const_get object_type.to_sym
        klass.connection = connection
        SObjectModel.generated_classes << klass
        generated_types << object_type
      end

      generated_types
    end

    private

    def describe(object_type)
      connection.describe object_type
    end

    def generated?(object_type)
      Object.const_get object_type.to_sym
      true
    rescue NameError
      false
    end
  end
end
