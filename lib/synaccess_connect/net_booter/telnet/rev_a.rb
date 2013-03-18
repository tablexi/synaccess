class RevA < NetBooter::Telnet

  def override_options
    {
      :prompt => /^\r>$/n,
      :status_string => 'On'
    }
  end

  def statuses
    with_connection do
      parse_status @connection.cmd("pshow")
    end
  end

private
  def authenticate
    sleep 0.1
    @connection.puts(@options[:username])
    sleep 0.1
    @connection.puts(@options[:password])
    @connection.cmd('')
    sleep 0.1
  end
end
