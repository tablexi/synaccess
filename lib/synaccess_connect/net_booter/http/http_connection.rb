require "net/http"
require 'nokogiri'

class NetBooter::HttpConnection
  def initialize(host, options = {})
    @host = host
    @options = {
      :port => 80
    }.merge(options)
  end

  def status(outlet = 1)
    statuses.fetch outlet do
      raise Exception.new('Error communicating with relay')
    end
  end

  def toggle_on(outlet = 1)
    toggle(true, outlet)
  end

  def toggle_off(outlet = 1)
    toggle(false, outlet)
  end

  def toggle(status, outlet = 1)
    current_status = status(outlet)
    toggle_relay(outlet) if current_status != status
    puts "toggle should now be: #{status}"
    status
  end

  # Should return a hash of the outlet number and a boolean indicating status
  # { 1 => true, 2 => false }
  def statuses
    raise NotImplementedError.new
  end

  # toggle_relay should actually send the request to the relay to toggle it
  def toggle_relay(outlet)
    raise NotImplementedError.new('Must implement toggle_relay in subclass')
  end

private

  def get_request(path)
    resp = nil
    begin
      Timeout::timeout(5) do
        resp = do_http_request(path)
      end
    rescue Exception => e
      puts e.message
      raise Exception.new("Error connecting to relay: #{e.message}")
    end
    resp
  end

  def do_http_request(path)
    resp = nil
    Net::HTTP.start(@host) do |http|
      req = Net::HTTP::Get.new(path)

      req.basic_auth @options[:username], @options[:password] if @options[:username] && @options[:password]

      resp = http.request(req)

      # Error checking. Allow 200s and 302s
      unless ['200', '302'].include? resp.code
        raise Exception.new "Relay responded with #{resp.code}. Perhaps you have the wrong relay type specified."
      end
    end
    resp
  end

end
