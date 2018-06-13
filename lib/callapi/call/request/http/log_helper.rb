require 'colorize'

module Callapi::Call::Request::Http::LogHelper
  def with_logging
    return yield if Callapi::Config.log_level == :none

    start_time = Time.now

    add_api_host_log
    add_request_path_log
    add_request_headers_log
    add_request_params_log

    yield.tap do |response|
      add_response_log(response)
      add_response_summary_log(start_time)
    end
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

  def add_response_log(response)
    response.tap do |response|
      "RESPONSE: [#{response.code}]\n".tap do |string|
        string << (response.body.nil? ? '[EMPTY BODY]' : response.body)
        string = string.force_encoding('utf-8')
        puts string.colorize(:light_blue)
      end
    end
  rescue StandardError => e
    puts 'Unable to parse response'.center(80, '-').colorize(:red).on_yellow
  end

  def add_response_summary_log(start_time)
    puts "request send (#{(Time.now - start_time).round(3)} sec)".center(80, '-').colorize(:white).on_blue
  end
end
