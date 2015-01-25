class Callapi::Call::Errors < StandardError
  STATUS_TO_ERROR_CLASS = {
    401 => 'NotAuthorized',
    404 => 'NotFound'
  }

  def self.error_by_status(status)
    error_class_name = STATUS_TO_ERROR_CLASS[status]
    unless error_class_name
      error_class_name = case status
        when 500..599 then 'ServerError'
        when 400..499 then 'ClientError'
        when 300..399 then 'RedirectionError'
        else
          'ServerError'
      end
    end
    "Callapi::Call::Errors::#{error_class_name}".constantize
  end

  class ApiError < Callapi::Call::Errors
    def initialize(status, message)
      super "#{status}: #{message}"
    end
  end

  class ServerError < ApiError; end
  class ClientError < ApiError; end
  class RedirectionError < ApiError; end
  class NotAuthorized < ApiError; end
  class NotFound < ApiError; end

  class UnknownHttpMethod < Callapi::Call::Errors
    def initialize
      super 'Could not retrieve HTTP method from Call class name'
    end
  end

  class ApiHostNotSet < Callapi::Call::Errors
    def initialize
      super 'Set API host with Callapi::Config.api_host = "http://yourapi.host.com"'
    end
  end

  class CouldNotFoundRequestMockFile < Callapi::Call::Errors
    def initialize(file_path)
      super "Expected \"#{file_path}\""
    end
  end

  class MissingParam < Callapi::Call::Errors
    def initialize(request_path, param_keys_to_replace, missing_keys)
      param_keys_to_replace.each do |param_key|
        request_path.sub!(param_key + '_param', ':' + param_key)
      end
      super "could not found: #{missing_keys.join(', ')} for \"#{request_path}\""
    end
  end
end