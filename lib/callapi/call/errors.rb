class Callapi::Call::Errors < StandardError
  STATUS_TO_ERROR_CLASS = {
    401 => 'NotAuthorized'
  }

  def self.error_by_status(status)
    error_class_name = STATUS_TO_ERROR_CLASS[status] || 'ApiCrashed'
    "Callapi::Call::Errors::#{error_class_name}".constantize
  end

  class ApiCrashed < Callapi::Call::Errors; end
  class NotAuthorized < Callapi::Call::Errors; end

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
end