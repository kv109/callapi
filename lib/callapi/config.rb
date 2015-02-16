class Callapi::Config
  DEFAULT_REQUEST_STRATEGY = 'Callapi::Call::Request::Api'
  DEFAULT_RESPONSE_PARSER  = 'Callapi::Call::Parser::Json'
  DEFAULT_MOCKS_DIRECTORY  = 'mocked_calls'
  DEFAULT_PATH_PREFIX = nil

  class << self
    attr_reader :mocks_directory
    attr_accessor :api_host
    attr_writer :api_path_prefix, :default_response_parser, :default_request_strategy

    def configure
      yield self if block_given?
    end

    def default_request_strategy
      @default_request_strategy ||= Kernel.const_get DEFAULT_REQUEST_STRATEGY
    end

    def api_path_prefix
      @api_path_prefix ||= DEFAULT_PATH_PREFIX
    end

    def default_response_parser
      @default_response_parser ||= Kernel.const_get DEFAULT_RESPONSE_PARSER
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

    def log_level=(log_level)
      @log_level = log_level
    end

    def log_level
      @log_level ||= :debug
    end
  end
end