require 'uri'
require 'net/http'
require 'json'
require 'cgi'

require_relative 'http'
require_relative 'query_result'
require_relative 'errors'

module Yamori
  module Rest
    class Client
      attr_reader :instance_url, :access_token, :api_version

      def initialize(instance_url:, access_token:, api_version:)
        @instance_url = instance_url
        @access_token = access_token
        @api_version = api_version
        @http = Http.new(instance_url, access_token)
      end

      def http
        @http
      end

      def query(soql)
        response = http.get "/services/data/v#{api_version}/query?q=#{CGI.escape(soql)}"
        QueryResult.new(response)
      end

      def describe(object_type)
        response = http.get "/services/data/v#{api_version}/sobjects/#{object_type.to_sym}/describe"
        JSON.parse(response)
      end

      def find(object_type, id)
        response = http.get "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}"
        JSON.parse(response)
      end

      def create(object_type, values)
        response = http.post "/services/data/v#{api_version}/sobjects/#{object_type}/", values
        JSON.parse(response)['id']
      end

      def update(object_type, id, values)
        http.patch "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/", values
        id
      end

      def delete(object_type, id)
        http.delete "/services/data/v#{api_version}/sobjects/#{object_type}/#{id}/"
        id
      end
    end
  end
end
