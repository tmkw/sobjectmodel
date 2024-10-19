module Yamori
  module Rest
    class QueryResult
      def initialize(api_response)
        @response = JSON.parse(api_response)
      end

      def total_size
        @total_size ||= response['totalSize']
      end

      def done?
        @done ||= response['done']
      end

      alias completed? done?

      def next_records_url
        @next_records_url ||= response['nextRecordsUrl']
      end

      def to_records(model_class: nil)
        records.each_with_object([]) do |h, a|
          record = prepare_record(h)
          a << (model_class ? model_class.new(**record) : record)
        end
      end

      private

      def response
        @response
      end

      def records
        @records ||= response['records']
      end

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
    end
  end
end
