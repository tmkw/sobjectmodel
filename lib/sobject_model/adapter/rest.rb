require_relative 'base'
require_relative '../rest/client'

module SObjectModel
  module Adapter
    class Rest < Base
      def initialize(rest_client)
        @client = rest_client
      end

      def exec_query(soql, model_class: nil)
        result = client.query(soql)
        result.to_records(model_class: model_class)
      end

      def describe(object_type)
        client.describe(object_type)
      end

      def find(object_type, id, klass)
        attributes = client.find(object_type, id)
        klass.new(**attributes)
      rescue ::SObjectModel::Rest::RecordNotFoundError
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

      def client
        @client
      end
    end
  end
end
