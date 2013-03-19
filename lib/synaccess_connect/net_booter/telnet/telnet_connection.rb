require 'net/telnet'

class NetBooter::TelnetConnection
  def initialize(host, options = {})
    @host = host
    @options = { :port => 23,
      :binmode => false,
      :prompt => /^[>]/n,
      :timeout => 1,
      :status_string => 'ON'
      }.merge(override_options).merge(options)
  end

  def override_options
    {}
  end

  def status(outlet = 1)
    statuses.fetch outlet do
      raise Exception.new('Error communicating with relay')
    end
  end

  def statuses
    with_connection :default => {} do
      local_statuses
    end
  end

  def toggle_on(outlet = 1)
    toggle(true, outlet)
  end

  def toggle_off(outlet = 1)
    toggle(false, outlet)
  end

  def toggle(status, outlet = 1)
    status_string = status ? '1' : '0'
    with_connection do
      @connection.cmd("pset #{outlet} #{status_string}")
    end
    status
  end

private

  def authenticate
    raise NotImplementedException.new('Must implement in subclass')
  end

  # Parse the text that we get back from pshow
  # returns hash of { channel => boolean_status }
  def parse_status(response)
    statuses = {}
    return statuses unless response

    response.split("\n").each do |line|
      parts = line.split('|').map &:strip
      next unless parts[0] =~ /^\d+/
      statuses[parts[0].to_i] = parts[2] == @options[:status_string]
    end
    statuses
  end

  def connect
    # puts "connecting to #{@host}:#{@options[:port]}"
    @connection = Net::Telnet::new(
      'Host' => @host,
      'Port' => @options[:port],
      'Binmode' => @options[:binmode],
      'Prompt' => @options[:prompt],
      'Timeout' => @options[:timeout]
    )
    authenticate if @options[:username] && @options[:password]
  end

  def disconnect
    begin
      @connection.close if @connection
    rescue
      # do nothing
    end
  end

  def with_connection options = {}
    begin
      connect
      output = yield
    rescue Exception => e
      puts "ERROR! #{e.message}"
      output = options[:default] if options[:default]
    ensure
      disconnect
    end

    output
  end

end