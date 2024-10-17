require 'uri'
require 'net/http'
require 'json'
require 'cgi'

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

    class Client
      attr_reader :instance_url, :access_token, :api_version

      def initialize(instance_url:, access_token:, api_version:)
        @instance_url = instance_url
        @access_token = access_token
        @api_version = api_version
      end

      def query(soql)
        response = get "/services/data/v#{api_version}/query?q=#{CGI.escape(soql)}"
        QueryResult.new(response)
      end

      def describe(object_type)
        response = get "/services/data/v#{api_version}/sobjects/#{object_type.to_sym}/describe"
        JSON.parse(response)
      end

      def find(object_type, id)
        response = get "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}"
        JSON.parse(response)
      end

      def create(object_type, values)
        response = post "/services/data/v#{api_version}/sobjects/#{object_type}/", values
        JSON.parse(response)['id']
      end

      def update(object_type, id, values)
        patch "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/", values
        id
      end

      def delete(object_type, id)
        _delete "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/"
        id
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
    end
  end
end
