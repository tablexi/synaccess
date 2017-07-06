module NetBooter

  module Telnet

    class RevB < TelnetConnection

      def local_statuses
        @connection.cmd("")
        sleep 0.25
        parse_status @connection.cmd("pshow")
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

  end

end
