require 'colorize'

module Callapi::Call::Request::Http::LogHelper
  def with_logging
    return yield if Callapi::Config.log_level == :none

    start_time = Time.now

    string = ''

    add_api_host_log
    add_request_path_log
    add_request_headers_log
    add_request_params_log

    response = yield

    add_response_log(response, start_time)

  rescue StandardError => e
    puts 'Exception occured, skipping logs'.center(80, '-').colorize(:red).on_yellow
    raise e
  end

  def add_api_host_log
    string = ''
    string << uri.host
    string << ":#{uri.port}" if uri.port

    puts "Sending request to #{string}".center(80, '-').colorize(:white).on_blue
  end

  def add_request_path_log
    'PATH:    '.tap do |string|
      string << "#{request_method.to_s.upcase} "
      string << "#{uri.path}"
      puts string.colorize(:magenta)
    end
  end

  def add_request_headers_log
    'HEADERS: '.tap do |string|
      string << "#{headers}"
      puts string.colorize(:cyan)
    end
  end

  def add_request_params_log
    'PARAMS:  '.tap do |string|
      string << "#{params}"
      puts string.colorize(:green)
    end
  end

  def add_response_log(response, start_time)
    response.tap do |response|
      "RESPONSE: [#{response.code}]\n".tap do |string|
        string << (response.body.nil? ? '[EMPTY BODY]' : response.body)
        puts string.colorize(:light_blue)
      end

      puts "request send (#{(Time.now - start_time).round(3)} sec)".center(80, '-').colorize(:white).on_blue
    end
  end
end