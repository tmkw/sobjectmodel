require_relative 'base'
require_relative '../rest/client'

module Yamori
  module Adapter
    class Rest < Base
      def initialize(rest_client)
        @client = rest_client
      end

      def exec_query(soql, model_class: nil)
        result = client.query(soql)

        result.records.each_with_object([]) do |h, a|
          record = prepare_record(h)
          a << (model_class ? model_class.new(**record) : record)
        end
      end

      def describe(object_type)
        client.describe(object_type)
      end

      def find(object_type, id, klass)
        attributes = client.find(object_type, id)
        klass.new(**attributes)
      rescue ::Yamori::Rest::RecordNotFoundError
        nil
      end

      def create(object_type, values, klass = nil)
        id = client.create(object_type, values)
        return id if klass.nil?

        find(object_type, id, klass)
      end

      def update(object_type, id, values)
        client.update(object_type, id, values)
      end

      def delete(object_type, id)
        client.delete(object_type, id)
      end

      def query(soql, klass)
        exec_query(soql, model_class: klass)
      end

      private

      def prepare_record(hash)
        hash.delete 'attributes'

        hash.keys.each do |k|
          if parent?(hash[k])
            hash[k] = prepare_record(hash[k])
          elsif children?(hash[k])
            hash[k] = hash[k]['records'].map{|h| prepare_record(h)}
          end
        end

        hash
      end

      def children?(h)
        return false unless h.instance_of?(Hash)

        h.has_key? 'records'
      end

      def parent?(h)
        return false unless h.instance_of?(Hash)

        h.has_key?('records') == false
      end

      def client
        @client
      end
    end
  end
end
