require 'uri'
require 'net/http'
require 'json'
require 'cgi'
require_relative 'base'

module Yamori
  module Connection
    class Rest < Base
      attr_reader :instance_url, :access_token, :api_version

      def initialize(instance_url:, access_token:, api_version:)
        @instance_url = instance_url
        @access_token = access_token
        @api_version = api_version
      end

      def exec_query(soql, model_class: nil)
        response = get "/services/data/v#{api_version}/query?q=#{CGI.escape(soql)}"
        result = QueryResult.new(response)

        result.records.each_with_object([]) do |h, a|
          record = prepare_record(h)
          a << (model_class ? model_class.new(**record) : record)
        end
      end

      def describe(object_type)
        response = get "/services/data/v#{api_version}/sobjects/#{object_type.to_sym}/describe"
        JSON.parse(response)
      end

      def find(object_type, id, klass)
        response = get "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}"
        attributes = JSON.parse(response)
        klass.new(**attributes)
      rescue RecordNotFoundError
        nil
      end

      def create(object_type, values, klass = nil)
        response = post "/services/data/v#{api_version}/sobjects/#{object_type}/", values
        id = JSON.parse(response)['id']
        return id if klass.nil?

        find(object_type, id, klass)
      end

      def update(object_type, id, values)
        patch "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/", values
        id
      end

      def delete(object_type, id)
        _delete "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/"
        id
      end

      def query(soql, klass)
        exec_query(soql, model_class: klass)
      end

      private

      def http_headers
        { 'Authorization' => ('Bearer %{token}' % {token: access_token}), 'Content-Type'  => 'application/json' }
      end

      def get(path)
        url = URI.parse(instance_url + path)
        res = Net::HTTP.get(url, http_headers)

        if res =~/errorCode/
          err = JSON.parse(res).first
          if err['errorCode'] == 'NOT_FOUND'
            raise RecordNotFoundError.new
          else
            raise RequestError.new(err['errorCode'], err['message'])
          end
        end

        res
      end

      def post(path, data)
        response = post_request(path, data)
        response.body
      end

      def patch(path, data)
        response = post_request(path + '?_HttpMethod=PATCH', data)
        response.code
      end

      def _delete(path)
        response = post_request(path + '?_HttpMethod=DELETE', '')
        response.code
      end

      def post_request(path, data)
        url = URI.parse(instance_url + path)
        response = Net::HTTP.post(url, JSON.dump(data), http_headers)
        raise RequestError.new(response.code, response.message) if response.is_a?(Net::HTTPClientError) || response.is_a?(Net::HTTPServerError)

        response
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

        def records
          @records ||= response['records']
        end

        private

        def response
          @response
        end
      end

      class RecordNotFoundError < StandardError
      end

      class RequestError < StandardError
        attr_reader :error_code, :error_message
        def initialize(code, msg)
          @error_code = code
          @error_message  = msg
          super(to_s)
        end

        def to_s
          %|[#{@code}] #{@msg}|
        end
      end
    end
  end
end
