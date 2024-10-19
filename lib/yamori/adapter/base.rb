module Yamori
  module Adapter
    class Base
      def exec_query(soql, model_class: nil)
        raise 'this method is not implemented'
      end

      def find(object_type, id, klass)
        raise 'this method is not implemented'
      end

      def create(object_type, values, klass = nil)
        raise 'this method is not implemented'
      end

      def update(object_type, id, values)
        raise 'this method is not implemented'
      end

      def delete(object_type, id) 
        raise 'this method is not implemented'
      end

      def query(soql, klass)
        raise 'this method is not implemented'
      end

      def describe(object_type)
        raise 'this method is not implemented'
      end
    end
  end
end 
  
