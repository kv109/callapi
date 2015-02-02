class Callapi::Errors < StandardError
  STATUS_TO_ERROR_CLASS = {
    401 => 'NotAuthorizedError',
    404 => 'NotFoundError'
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
    "Callapi::#{error_class_name}".constantize
  end
end

class Callapi::ApiError < StandardError
  def initialize(status, message)
    super "#{status}: #{message}"
  end
end

class Callapi::ServerError < Callapi::ApiError; end
class Callapi::ClientError < Callapi::ApiError; end
class Callapi::RedirectionError < Callapi::ApiError; end
class Callapi::NotAuthorizedError < Callapi::ApiError; end
class Callapi::NotFoundError < Callapi::ApiError; end

class Callapi::UnknownHttpMethodError < StandardError
  def initialize
    super 'Could not retrieve HTTP method from Call class name'
  end
end

class Callapi::ApiHostNotSetError < StandardError
  def initialize
    super 'Set API host with Callapi::Config.api_host = "http://yourapi.host.com"'
  end
end

class Callapi::CouldNotFoundMockRequestFileError < StandardError
  def initialize(file_path)
    super "Expected \"#{file_path}\""
  end
end

class Callapi::MissingParamError < StandardError
  def initialize(request_path, param_keys_to_replace, missing_keys)
    param_keys_to_replace.each do |param_key|
      request_path.sub!(param_key + '_param', ':' + param_key)
    end
    super "could not found: #{missing_keys.join(', ')} for \"#{request_path}\""
  end
end
