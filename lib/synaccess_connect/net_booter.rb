require 'socket'

class NetBooter
  def initialize(host, port = 23)
    @host = host
    @port = port
  end

  def status(channel = 1)
    statuses[channel]
  end

  def statuses
    _with_connection do
      _parse_status(_send_message('pshow'))
    end
  end

  def toggle(channel = 1, on)
    _with_connection do
      on_msg = on ? '1' : '0'
      _send_message("pset #{channel.to_i} #{on_msg}")
    end
    on
  end

  def toggle_on(channel = 1)
    toggle(channel, true)
  end

  def toggle_off(channel = 1)
    toggle(channel, false)
  end

  def login(username, password)
    _receive_message
    _receive_message
    # sleep 1
    puts "logging in"
    @socket.send("#{username}\r", 0)
    # sleep 1
    @socket.send("#{password}\r", 0)

    sleep 0.1
    puts "done logging in"
  end

  def connect
    puts "connecting to #{@host}:#{@port}"
    @socket = TCPSocket.new @host, @port
    puts "socket: #{@socket}"
    #TODO handle no socket

    # optional - capture incoming message. The message contains some garbled characters
    # characters used for Telnet Mode setting. Ignor it.
    # connect_message = @socket.recvfrom(1024)
    # puts connect_message
    login('admin', 'admin')
  end

  def disconnect
    puts 'disconnecting'
    _send_message("logout")
    @socket.close
  end

private

  def authenticate
    puts "authenticating"
  end

  def _receive_message(options = {})
    # First two lines of response are usually meaningless
    options = {skip: 2}.merge(options)
    i = 0
    message = []
    while line = @socket.gets
      puts "l: #{line.gsub(/\r/, '\r').gsub(/\n/, '\n')}"
      # Revision B firmware uses \r\r\n
      # Old firmware has \r>\n at the end
      break if line == "\r\r\n" || line == "\r>\n"
      message << line.strip if i >= options[:skip]
      i += 1
    end
    # remove empty strings
    message.compact.select { |m| m.length > 0 }
  end

  # Parse the text that we get back from pshow
  # returns hash of { channel => boolean_status }
  def _parse_status(response)
    statuses = {}
    response.each do |line|
      parts = line.split('|').map &:strip
      next unless parts[0] =~ /^\d+/
      statuses[parts[0].to_i] = parts[2] == 'ON'
    end
    statuses
  end

  # Takes a block and wraps it within a socket connection
  def _with_connection
    connect
    output = yield
    disconnect

    output
  end

  def _send_message(message)
    puts "sending: #{message}"
    @socket.puts "#{message}\r"
    response = _receive_message
    puts "response: #{response}"
    response
  end

end