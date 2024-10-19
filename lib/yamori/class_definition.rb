require_relative './schema'
require_relative './base_methods'
require_relative './dml_methods'
require_relative './query_methods'

module Yamori
  class ClassDefinition
    attr_reader :schema

    def initialize(schema)
      @schema = Schema.new(schema)
    end

    def to_s
      <<~Klass
        Class.new do
          include ::Yamori::BaseMethods
          include ::Yamori::DmlMethods
          include ::Yamori::QueryMethods

          attr_reader :original_attributes, :current_attributes, :updated_attributes

          #{ class_methods }

          #{ field_attribute_methods }
          #{ parent_relation_methods }
          #{ child_relation_methods }
        end
      Klass
    end

    def class_methods
      <<~EOS
        class << self
          def field_names
            @field_names ||= #{ schema.field_names }
          end

          def parent_relations
            @parent_relations ||= #{ schema.parent_relations }
          end

          def child_relations
            @child_relations ||= #{ schema.child_relations }
          end
        end
      EOS
    end

    def field_attribute_methods
      schema.field_names.each_with_object('') do |name, s|
        s << <<~EOS
          def #{name}
            @#{name}
          end

          def #{name}=(value)
            @#{name} = value
            return if %i[Id LastModifiedDate IsDeleted SystemModstamp CreatedById CreatedDate LastModifiedById].include?(:#{name})

            current_attributes[:#{name}] = value
            if current_attributes[:#{name}] == original_attributes[:#{name}]
              updated_attributes[:#{name}] = nil
            else
              updated_attributes[:#{name}] = value
            end
          end
        EOS
      end
    end

    def parent_relation_methods
      schema.parent_relations.each_with_object('') do |r, s|
        s << <<~EOS
          def #{r[:name]}
            @#{r[:name]}
          end

          def #{r[:name]}=(attributes)
            @#{r[:name]} = attributes.nil? ? nil : #{r[:class_name]}.new(attributes)
          end
        EOS
      end
    end

    def child_relation_methods
      schema.child_relations.each_with_object('') do |r, s|
        s << <<~EOS
          def #{r[:name]}
            @#{r[:name]}
          end

          def #{r[:name]}=(records)
            @#{r[:name]} = records.map{|attributes| #{r[:class_name]}.new(attributes)}
          end
        EOS
      end
    end
  end
end
