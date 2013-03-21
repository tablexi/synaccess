require "net/http"
require 'nokogiri'

class NetBooter::HttpConnection
  def initialize(host, options = {})
    @host = host
    @options = {
      :port => 80
    }.merge(options)
  end

  # Get the status of an outlet
  #
  # Example:
  #   >> netbooter.status(2)
  #   => false
  #
  # Arguments:
  # +outlet+ Outlet number you want to check (1-based)
  #
  # Returns:
  # boolean - on/off status of the outlet
  def status(outlet = 1)
    statuses.fetch outlet do
      raise Exception.new('Error communicating with relay')
    end
  end

  # Turn on the specified outlet
  # Example:
  #   >> netbooter.toggle_on(2)
  #   => true
  #
  # Arguments:
  # +outlet+ Outlet you want to turn on (1-based)
  #
  # Returns:
  # boolean - The new status of the outlet (should be true)
  def toggle_on(outlet = 1)
    toggle(outlet, true)
  end

  # Turn off the specified outlet
  # Example:
  #   >> netbooter.toggle_off(2)
  #   => true
  #
  # Arguments:
  # +outlet+ Outlet you want to turn off (1-based)
  #
  # Returns:
  # boolean - The new status of the outlet (should be false)
  def toggle_off(outlet = 1)
    toggle(outlet, false)
  end

  # Toggle the status of an outlet
  #
  # Example:
  #  >> netbooter.toggle(1, false)
  #  => false
  #
  # Arguments:
  # +outlet+ The outlet you want to toggle
  # +status+ Boolean. true to turn on, false to turn off
  #
  # Returns:
  # boolean - The new status of the outlet
  def toggle(outlet, status)
    current_status = status(outlet)
    toggle_relay(outlet) if current_status != status
    status
  end

  # Get the status of all outlets on the device. Needs to be defined
  # in a subclass.
  #
  # Example:
  #   >> netbooter.statuses
  #   => { 1 => true, 2 => false }
  #
  # Arguments: none
  #
  # Returns:
  # A hash containing the outlet numbers and their respective status
  def statuses
    raise NotImplementedError.new
  end

  # The method that contains the network command the relay. Needs to be defined
  # in a subclass.
  def toggle_relay(outlet)
    raise NotImplementedError.new('Must implement toggle_relay in subclass')
  end

private

  # Make an http request and return the result.
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
