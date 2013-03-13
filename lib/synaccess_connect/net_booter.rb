require 'socket'
class NetBooter
  def initialize(host, port = 23)
    @host = host
    @port = port
  end

  # def status(channel = 1)

  # end

  def toggle(channel = 1, on)
    _with_connection do
      on_msg = on ? '1' : '0'
      _send_message("pset #{channel.to_i} #{on_msg}\n\r")
    end
  end

  def toggle_on(channel = 1)
    toggle(channel, true)
  end

  def toggle_off(channel = 1)
    toggle(channel, false)
  end

  def connect
    puts 'connecting'
    @socket = ::TCPSocket.new @host, @port

    # optional - capture incoming message. The message contains some garbled characters
    # characters used for Telnet Mode setting. Ignor it.
    connect_message = @socket.recvfrom(1024)
    @socket.send("\r", 0)
  end

  def disconnect
    puts 'disconnecting'
    _send_message("logout\r")
    @socket.close
  end

private

  def _with_connection
    connect
    yield
    # without the sleep, the message doesn't get accepted even though it responds
    sleep 0.05
    disconnect
  end

  def _send_message(message)
    puts "sending: #{message}"
    response = @socket.send(message, 0)
    puts "response: #{response}"
    response
  end

end