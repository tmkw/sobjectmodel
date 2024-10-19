module Yamori
  module Rest
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
