class Callapi::Config
  DEFAULT_REQUEST_STRATEGY = 'Callapi::Call::Request::Api'
  DEFAULT_RESPONSE_PARSER  = 'Callapi::Call::Response::Json'
  DEFAULT_MOCKS_DIRECTORY  = 'mocked_calls'
  DEFAULT_PATH_PREFIX = ''

  class << self
    attr_reader :mocks_directory
    attr_accessor :api_host
    attr_writer :default_path_prefix, :default_response_parser, :default_request_strategy

    def configure
      yield self if block_given?
    end

    def default_request_strategy
      @default_request_strategy ||= DEFAULT_REQUEST_STRATEGY.constantize
    end

    def default_path_prefix
      @default_path_prefix ||= DEFAULT_PATH_PREFIX
    end

    def default_response_parser
      @default_response_parser ||= DEFAULT_RESPONSE_PARSER.constantize
    end

    def mocks_directory=(mocks_directory)
      [].tap do |paths|
        paths << Rails.root if defined?(Rails)
        paths << mocks_directory
        paths << '/'
        @mocks_directory = File.join(paths)
      end
    end

    def mocks_directory
      return @mocks_directory if @mocks_directory

      [].tap do |paths|
        paths << Rails.root if defined?(Rails)
        paths << DEFAULT_MOCKS_DIRECTORY
        paths << '/'
        @mocks_directory = File.join(paths)
      end
    end
  end
end