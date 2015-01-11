require 'colorize'

module Callapi::Call::Request::Http::LogHelper
  def with_logging
    string = ''
    string << uri.host
    string << ":#{uri.port}" if uri.port

    puts "Sending request to #{string}".center(80, '-').colorize(:white).on_blue
    'PATH:    '.tap do |string|
      string << "#{request_method.to_s.upcase} "
      string << "#{uri.path}"
      puts string.colorize(:magenta)
    end
    'HEADERS: '.tap do |string|
      string << "#{headers}"
      puts string.colorize(:cyan)
    end
    'PARAMS:  '.tap do |string|
      string << "#{params}"
      puts string.colorize(:green)
    end

    response = yield

    response.tap do |response|
      "RESPONSE:\n".tap do |string|
        string << (response.body.nil? ? '[EMPTY BODY]' : response.body)
        puts string.colorize(:light_blue)
      end

      puts 'request send'.center(80, '-').colorize(:white).on_blue
    end
  rescue StandardError => e
    puts "Displaying logs skipped:".center(80, '-').colorize(:red).on_yellow
    puts "#{e.class}: #{e.to_s}".center(80, '-').colorize(:red).on_yellow
  end
end