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
    File.read(file_path)
  rescue Errno::ENOENT
    raise Callapi::Call::Errors::CouldNotFoundRequestMockFile.new(file_path)
  end

  private

  def file_path
    Callapi::Config.mocks_directory + "#{@context.request_method}#{@context.request_path}" + MOCK_FORMAT
  end
end