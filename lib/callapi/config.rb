class Callapi::Config
  DEFAULT_REQUEST_STRATEGY = 'Callapi::Call::Request::Api'
  DEFAULT_RESPONSE_CLASS   = 'Callapi::Call::Response::Json'
  DEFAULT_MOCKS_DIRECTORY  = 'mocked_calls'
  DEFAULT_PATH_PREFIX = ''

  class << self
    attr_reader :mocks_directory
    attr_accessor :api_host
    attr_writer :default_path_prefix, :default_response_class, :default_request_strategy

    def configure
      yield self if block_given?
    end

    def default_request_strategy
      @default_request_strategy ||= DEFAULT_REQUEST_STRATEGY.constantize
    end

    def default_path_prefix
      @default_path_prefix ||= DEFAULT_PATH_PREFIX
    end

    def default_response_class
      @default_response_class ||= DEFAULT_RESPONSE_CLASS.constantize
    end

    def mocks_directory=(mocks_directory)
      @mocks_directory = defined?(Rails) ? Rails.root.to_s + '/' + mocks_directory + '/' : mocks_directory
    end

    def mocks_directory
      @mocks_directory ||= if defined?(Rails)
                             Rails.root.to_s + "/app/#{DEFAULT_MOCKS_DIRECTORY}/"
                           else
                             DEFAULT_MOCKS_DIRECTORY
                           end
    end
  end
end