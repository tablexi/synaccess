class RevB < NetBooter::TelnetConnection
  def statuses
    with_connection do
      @connection.cmd("")
      sleep 0.1
      parse_status @connection.cmd("pshow")
    end
  end

private

  def authenticate
    @connection.cmd('login')
    sleep 0.25
    @connection.puts(@options[:username])
    sleep 0.25
    @connection.puts(@options[:password])
  end
end
