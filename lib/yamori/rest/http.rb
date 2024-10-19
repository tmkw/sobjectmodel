require 'uri'
require 'net/http'
require 'json'

module Yamori
  module Rest
    class Http
      attr_reader :instance_url, :access_token

      def initialize(instance_url, access_token)
        @instance_url = instance_url
        @access_token = access_token
      end

      def get(path)
        url = URI.parse(instance_url + path)
        res = Net::HTTP.get(url, headers)

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

      def delete(path)
        response = post_request(path + '?_HttpMethod=DELETE', '')
        response.code
      end

      private

      def headers
        { 'Authorization' => ('Bearer %{token}' % {token: access_token}), 'Content-Type'  => 'application/json' }
      end

      def post_request(path, data)
        url = URI.parse(instance_url + path)
        response = Net::HTTP.post(url, JSON.dump(data), headers)
        raise RequestError.new(response.code, response.message) if response.is_a?(Net::HTTPClientError) || response.is_a?(Net::HTTPServerError)

        response
      end
    end
  end
end
