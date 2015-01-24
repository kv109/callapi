class Callapi::Call::Request::Mock < Callapi::Call::Request::Base
  extend Memoist
  #TODO: should not be hardcoded
  MOCK_FORMAT = '.json'

  def response
    OpenStruct.new(body: body, code: code)
  end

  def code
    '200'
  end

  def body
    File.read(file_path)  # add #with_logging
  rescue Errno::ENOENT
    raise Callapi::Call::Errors::CouldNotFoundRequestMockFile.new(file_path)
  end

  private

  def file_path
    File.join(Callapi::Config.mocks_directory, @context.request_method.to_s, file_name + MOCK_FORMAT)
  end

  def file_name
    @context.request_path
  end
end