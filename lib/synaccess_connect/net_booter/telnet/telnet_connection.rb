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

  def toggle(outlet, status)
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
    retry_block 5 do
      @connection = Net::Telnet::new(
        'Host' => @host,
        'Port' => @options[:port],
        'Binmode' => @options[:binmode],
        'Prompt' => @options[:prompt],
        'Timeout' => @options[:timeout]
      )
      authenticate if @options[:username] && @options[:password]
    end
  end

  def disconnect
    begin
      @connection.close if @connection
    rescue
      # do nothing
    end
    # needs a little bit of delay after disconnecting
    # if so the next connection doesn't get refused while
    # this one is closing. Number arrived at by experimentation
    sleep 0.02
  end

  def with_connection options = {}
    begin
      connect
      raise Exception.new('Unable to connect') if @connection.nil?
      output = yield
    rescue Exception => e
      puts "ERROR! #{e.message}"
      # puts e.backtrace.join("\n")
      output = options[:default] if options[:default]
    ensure
      disconnect
    end

    output
  end

  def retry_block max_attempts, options = {}
    max_attempts.times do |i|
      begin
        yield
        break # if we made it through the yield without an error we can break
      rescue Exception => e
        puts e.message
        raise e if i + 1 >= max_attempts
      end
    end
  end

end