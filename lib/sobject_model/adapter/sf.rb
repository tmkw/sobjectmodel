require_relative 'base'

module SObjectModel
  module Adapter
    class Sf < Base
      attr_reader :target_org

      def initialize(sf_main, target_org:)
        @sf = sf_main
        @target_org = target_org
      end

      def exec_query(soql, format: nil, bulk: false, wait: nil, model_class: nil)
        sf.data.query(soql, target_org: target_org, format: format, bulk: bulk, wait: wait, model_class: model_class)
      end

      def find(object_type, id, klass)
        sf.data.get_record object_type, record_id: id, target_org: target_org, model_class: klass
      end

      def create(object_type, values, klass = nil)
        id = sf.data.create_record object_type, values: values, target_org: target_org
        return id if klass.nil?

        find(object_type, id, klass)
      end

      def update(object_type, id, values)
        sf.data.update_record object_type, record_id: id, where: nil, values: values, target_org: target_org
      end

      def delete(object_type, id)
        sf.data.delete_record object_type, record_id: id, where: nil, target_org: target_org
      end

      def query(soql, klass, format = nil)
        sf.data.query soql, target_org: target_org, format: format, model_class: klass
      end

      def describe(object_type)
        schema = sf.sobject.describe(object_type, target_org: target_org)
        schema.to_h # convert to raw command response
      end

      private

      def sf
        @sf
      end
    end
  end
end
